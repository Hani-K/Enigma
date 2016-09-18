#!/sbin/busybox sh

cat << CTAG
{
    name:IO,
    elements:[
    	{ SPane:{
		title:"I/O Schedulers",
		description:" Set the active I/O elevator algorithm. The I/O Scheduler decides how to prioritize and handle I/O requests. More info: <a href='http://timos.me/tm/wiki/ioscheduler'>Wiki</a>"
    	}},
	{ SDescription:{
		description:""
	}},
	{ SOptionList:{
		title:"Storage scheduler",
		default:`cat /sys/block/mmcblk0/queue/scheduler | busybox awk 'NR>1{print $1}' RS=[ FS=]`,
		action:"ioset scheduler",
		values:[`while read values; do busybox printf "%s, \n" $values | busybox tr -d '[]'; done < /sys/block/mmcblk0/queue/scheduler`],
			notify:[
				{
					on:APPLY,
					do:[ REFRESH, CANCEL ],
					to:"/sys/block/mmcblk0/queue/iosched"
				},
				{
					on:REFRESH,
					do:REFRESH,
					to:"/sys/block/mmcblk0/queue/iosched"
				}
			]
	}},
	{ SDescription:{
		description:" "
	}},
	{ SSeekBar:{
		title:"Storage Read-Ahead",
		max:2048,
		min:64,
		unit:" KB",
		step:64,
		default:`cat /sys/block/mmcblk0/queue/read_ahead_kb`,
		action:"ioset queue read_ahead_kb"
	}},
	{ SDescription:{
		description:" "
	}},
	{ SPane:{
		title:"General I/O Tunables",
		description:" Set the internal storage general tunables"
	}},
	{ SDescription:{
		description:" "
	}},
	{ SCheckBox:{
		description:" Draw entropy from spinning (rotational) storage. Default is Disabled",
		label:"Add Random",
		default:`cat /sys/block/mmcblk0/queue/add_random`,
		action:"ioset queue add_random"
	}},
	{ SDescription:{
		description:" "
	}},
	{ SCheckBox:{
		description:" Maintain I/O statistics for this storage device. Disabling will break I/O monitoring apps. Default is Enabled.",
		label:"I/O Stats",
		default:`cat /sys/block/mmcblk0/queue/iostats`,
		action:"ioset queue iostats"
	}},
	{ SDescription:{
		description:" "
	}},
	{ SCheckBox:{
		description:" Treat device as rotational storage. Default is Disabled",
		label:"Rotational",
		default:`cat /sys/block/mmcblk0/queue/rotational`,
		action:"ioset queue rotational"
	}},
	{ SDescription:{
		description:" "
	}},
	{ SSeekBar:{
		title:" No Merges",
		description:" Types of merges (prioritization) the scheduler queue for this storage device allows. Default is All.",
		default:`cat /sys/block/mmcblk0/queue/nomerges`,
		action:"ioset queue nomerges",
		values:{
			`NM='0:"All", 1:"Simple Only", 2:"None",'
			echo $NM`
		}
	}},
	{ SDescription:{
		description:" "
	}},
	{ SSeekBar:{
		title:"RQ Affinity",
		description:" Try to have scheduler requests complete on the CPU core they were made from. Higher is more aggressive. Some kernels only support 0-1. Default is 1.",
		default:`cat /sys/block/mmcblk0/queue/rq_affinity`,
		action:"ioset queue rq_affinity",
		values:{
			`RQA='0:"0: Disabled", 1:"1", 2:"2"'
			echo $RQA`
		}
	}},
	{ SDescription:{
		description:" "
	}},
	{ SPane:{
		title:"I/O Scheduler Tunables"
	}},
	{ SDescription:{
		description:""
	}},
	{ STreeDescriptor:{
		path:"/sys/block/mmcblk0/queue/iosched",
		generic: {
			directory: {},
			element: {
				SGeneric: { title:"@BASENAME" }
			}
		},
		exclude: [ "weights", "wr_max_time" ]
	}},
    ]
}
CTAG
