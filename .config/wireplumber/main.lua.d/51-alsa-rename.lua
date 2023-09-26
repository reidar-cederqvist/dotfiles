rule = {
	matches = {
		{
			{ "node.name", "equals", "alsa_output.usb-Corsair_CORSAIR_VIRTUOSO_XT_Wireless_Gaming_Receiver_16b61505000600da-00.analog-stereo" },
		},
	},
	apply_properties = {
		[ "node.description" ] = "Corsair Wireless Headset",
	},
}

table.insert(alsa_monitor.rules, rule)
