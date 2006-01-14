#*** test.pl Wed Jan 11 18:41:02 2006 ***#
# Copyright (C) 2006 T.Knorr
# create-soft@tiscali.de
# All rights reserved!
#-------------------------------------------------
 use strict;
 use warnings;
 use Tk;
 use lib::Tk::Mirror;
#-------------------------------------------------
 my $mw = MainWindow->new();
 $mw->title("Mirror Directories");
 $mw->geometry("+5+5");
 my $mirror = $mw->Mirror(
# first it should work without options
#	-localdir		=> "TestA",
# 	-remotedir	=> '/',
# 	-ftpserver	=> "my_ftp_server",
# 	-usr		=> "my_user_name",
# 	-pass		=> "my_ftp_password",
# 	-debug		=> 1, #  or undef or 0 (something false)
# 	-timeout		=> 30,
# 	-delete		=> "disabled", # or "enable"
# 	-connection	=> undef,
# 	-exclusions	=> [],
 	)->grid();
 for(keys(%{$mirror->GetChilds()}))
 	{
	$mirror->Subwidget($_)->configure(
 		-font	=> "{Times New Roman} 14 {bold}",
 		);
 	}
 for(qw/
 	TreeLocalDir
 	TreeRemoteDir
 	/)
 	{
 	$mirror->Subwidget($_)->configure(
 		-background	=> "#FFFFFF",
 		-width		=> 40,
 		-height		=> 20,
 		);
 	}
 for(qw/
 	bEntryUsr
 	EntryPass
 	bEntryFtpServer
 	bEntryLocalDir
 	bEntryRemoteDir
 	/)
 	{
 	$mirror->Subwidget($_)->configure(
 		-background	=> "#FFFFFF",
 		);
 	}
 $mw->Button(
 	-text		=> "Exit",
 	-command	=> sub { exit(); },
 	)->grid(
 	-row		=> 1,
 	);
 MainLoop();
#-------------------------------------------------


