#!/bin/sh

#
# gerrit-setup.sh -- setup local repository to use gerrit i.s.o. git
#

usage() {
    echo
    echo "Usage:"
    echo " $0 [--keep-origin] [--gerrit [<user>@]<host>] [<repository>]"
    echo
    echo "<host> = location of gerrit"
    echo "<user>@<host> = username for gerrit and location of gerrit"
    echo "Only needed once, or when changing gerrit hosts"
    echo
    echo "<repository> = repository (e.g. drgboot, drgos)"
    echo "(if <repository> is not specified it will be taken from the origin url)"
    echo
    echo "This script will setup some things useful for interracting"
    echo "with the Genexis gerrit (code review) server:"
    echo "  * commit hook to add Change-Id"
    echo "  * git remote config for convenient push to gerrit"
    echo
    echo "It should be executed from the the top directory of the "
    echo "cloned git repository."
    echo
    echo "The current remote.gerrit.url is used if available, including"
    echo "any username, but this can be overridden by the --gerrit option"
    echo
    echo "The origin url will also be rewritten to use the gerrit url,"
    echo "unless the --keep-origin option was given."
    echo
    echo "Examples:"
    echo
    echo "   gerrit-setup.sh --help"
    echo "        (shows this help message)"
    echo
    echo "   gerrit-setup.sh drgos.git"
    echo "        Uses default server, and uses 'drgos.git' as repository name"
    echo
    echo "   gerrit-setup.sh --gerrit user1@se-gerrit"
    echo "        Uses 'user1' for access, on server 'se-gerrit'"
    echo
    echo "   gerrit-setup.sh --keep-origin --gerrit user1@gerrit.genexislocal.nl"
    echo "        Doesn't change the origin url. The username for gerrit can be"
    echo "        different from the one in origin."
    echo "        This may be useful for using replicated repositories."
    echo
    exit 1
}

port=29418
GC=.git/config
gerrit=gerrit.genexislocal.nl

if [ "$1" = "--help" ]; then
    usage
fi

if [ "$1" = "--keep-origin" ]; then
    keeporigin=1
    shift
fi

# Get server name
if [ "$1" = "--gerrit" ]; then
    shift
    gerrit=$1
    [ $gerrit ] || usage
    shift
    echo "Switching gerrit to ${gerrit}"
else
    # Use existing gerrit URL, if available
    cur=$(git config --get remote.gerrit.url | sed -n 's/^ssh:\/\/\(.*\):.*/\1/p')
    if [ ${cur} ]; then
        gerrit=${cur}
        echo "Keeping gerrit at ${gerrit}"
    else
        echo "Defaulting to ${gerrit}"
    fi
fi

if echo $gerrit | grep -q '@'; then
    gerrituser=$(echo $gerrit | sed -n 's/^\(.*\)@.*$/\1/p')
    echo "Found user ${gerrituser}"
else
    gerrituser=reidar.cederqvist
    echo "USER is ${gerrituser}"
fi

repo=$1

# Check for git conf file
if ! [ -e $GC ]; then
    echo "File $GC not found. Not inside a repository?"
    usage
fi

# Get repo (drgboot, mcos, drgos, etc.)
if [ -z "$repo" ]; then
    url=$(git config --get remote.origin.url)
    url2=${url%%/}
    repo=${url2##*/}
    # strip the .git extension
    repo=$(basename $repo .git)
fi
[ -n "$repo" ] || {
    echo "Failed to figure out repository name"
    usage
}

# Test connection and check repo
echo "Testing connection to ${gerrit}, port ${port}"
version=$(ssh -p ${port} ${gerrit} gerrit version)
if [ $? -eq 255 ]; then
    echo "Connection failed."
    echo "Did you configure the SSH key for your machine and this gerrit server?"
    echo "Paste the output of cat ~/.ssh/id_rsa.pub into gerrit's web interface."
    echo "Note that this is different from the usual copying of the key."
    exit 1
elif [ $? -eq 0 ]; then
    echo "Found ${version}"
else
    echo "Found gerrit, version info not available"
fi

if ! ssh -p ${port} ${gerrit} gerrit ls-projects | grep -q "^${repo}$"; then
    echo "Project '${repo}' not found on ${gerrit}"
    echo "Verify manually with command:"
    echo "  ssh -p ${port} ${gerrit} gerrit ls-projects"
    exit 1
fi
echo "Found project ${repo} on ${gerrit}"

# Add commit hook
if ! [ -x .git/hooks/commit-msg ]; then
    echo "Installing commit-msg hook (for Change-Id)"
    scp -P ${port} -p ${gerrit}:hooks/commit-msg .git/hooks/
    chmod a+x .git/hooks/commit-msg
else
    echo "Found commit-msg hook"
fi

# Add latest commit template
# Note that the URL stays the same in case the template on Plaza is updated by "Action-> Attach new Version"
echo "Checking for commit message template, needs password to access Plaza"
wget --no-check-certificate --user=${gerrituser} --ask-password -nv -O .git/info/commit_template.txt https://plaza.genexislocal.nl/@api/deki/files/552/=commit_template.txt  &&  git config commit.template ${PWD}/.git/info/commit_template.txt

# Set origin URL
origin="ssh://${gerrit}:${port}/${repo}"
old=$(git config --get remote.origin.url)
if [ ${keeporigin} ]; then
    echo "Keeping origin at ${old}"
elif [ "${old}" != "${origin}" ]; then
    echo "Switching origin from ${old} to ${origin}"
    git remote set-url origin ${origin}
else
    echo "Origin URL is fine"
fi

# Set gerrit URL
url="ssh://${gerrit}:${port}/${repo}"
old=$(git config --get remote.gerrit.url)
if [ $? -ne 0 ]; then
    echo "Adding gerrit as a remote"
    (
	cat <<EOF
[remote "gerrit"]
	url = ssh://${gerrit}:${port}/${repo}
	fetch = +refs/heads/*:refs/remotes/gerrit/*
EOF
    ) >> $GC

elif [ "${old}" != "${url}" ]; then
    echo "Switching gerrit from ${old} to ${url}"
    git remote set-url gerrit ${url}

    echo "Cleaning existing for-X remotes"
    sed -i -e '/^\[remote "for-/,+2d' $GC

    echo "Cleaning existing drafts-X remotes"
    sed -i -e '/^\[remote "drafts-/,+2d' $GC
else
    echo "Gerrit URL is fine"
fi

# Fetch gerrit branches
echo "Fetching branches from gerrit"
git fetch gerrit

# Add special "for-" remotes for all branches
git branch -r | grep " gerrit/" | (
    while read br; do
	b="${br##gerrit/}"
	bs=$b
	[ "HEAD" != $b ] || continue

	if ! grep -q "remote \"for-$bs\"" $GC; then
            echo "Adding remote 'for-$bs'"
            (
                cat <<EOF
[remote "for-$bs"]
	url = ssh://${gerrit}:${port}/${repo}
	push = HEAD:refs/for/$b
EOF
            ) >> $GC
        fi

        if ! grep -q "remote \"drafts-$bs\"" $GC; then
            echo "Adding remote 'drafts-$bs'"
            (
                cat <<EOF
[remote "drafts-$bs"]
        url = ssh://${gerrit}:${port}/${repo}
        push = HEAD:refs/drafts/$b
EOF
            ) >> $GC
        fi

    done
)

### Process the submodules -- currently drgos only -- untested, may not work
##echo "Processing submodules ..."
##git submodule foreach "(cd ..; git config submodule.\$name.url ssh://${gerrit}:${port}/\$(basename \$name))"


