#-------------------------------------------------
use ExtUtils::MakeMaker;
#-------------------------------------------------
 WriteMakefile(
 	NAME		=> "Tk::Mirror",
 	VERSION_FROM	=> "lib/Tk/Mirror.pm",		# finds $VERSION
 	PREREQ_PM	=> {
 			'Net::MirrorDir'		=> '0',
 			'Net::UploadMirror'	=> '0',
 			'Net::DownloadMirror'	=> '0',
 			'Tk'			=> '0',
 			'Tk::Frame'		=> '0',
 			'Storable'			=> '0',
 			},				# e.g., Module::Name => 1.1
 	($] >= 5.005 ?					## Add these new keywords supported since 5.005
 	(ABSTRACT_FROM => "lib/Tk/Mirror.pm",		# retrieve abstract from module
 	AUTHOR	=> 'Torsten Knorr <knorrcpan@tiscali.de>') : ()),
 	);
#-------------------------------------------------



