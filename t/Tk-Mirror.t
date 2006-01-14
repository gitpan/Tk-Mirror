# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Tk-Mirror.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

 use Test::More tests => 119;
# use Test::More "no_plan";
BEGIN { use_ok('Tk::Mirror') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.
 use_ok("Tk");
 ok(my $mw = MainWindow->new());
 can_ok($mw, "title");
 $mw->title("Mirror Directories");
 can_ok($mw, "geometry");
 $mw->geometry("+5+5");
 can_ok($mw, "Mirror");
 ok(my $mirror = $mw->Mirror(
 	-localdir		=> "TestA",
 	-remotedir	=> "TestD",
 	-usr		=> 'my_ftp@username.de',
 	-ftpserver	=> "ftp.server.de",
 	-pass		=> "my_password",
 	));
 isa_ok($mirror, "Tk::Mirror");
 can_ok($mirror, "grid");
 ok($mirror->grid());
 can_ok($mirror, "Subwidget");
 can_ok($mirror, "GetChilds");
 ok(my $ref_h_childs = $mirror->GetChilds());
 my $sub_widget;
 for(keys(%{$ref_h_childs}))
 	{
	ok($sub_widget = $mirror->Subwidget($_));
 	can_ok($sub_widget, "configure"); 
 	$sub_widget->configure(
 		-font	=> "{Times New Roman} 14 {bold}",
 		);
 	}
 for(qw/
 	TreeLocalDir
 	TreeRemoteDir
 	/)
 	{
 	ok($sub_widget = $mirror->Subwidget($_));
 	can_ok($sub_widget, "configure");
 	$sub_widget->configure(
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
 	ok($sub_widget = $mirror->Subwidget($_));
 	can_ok($sub_widget, "configure");
 	$sub_widget->configure(
 		-background	=> "#FFFFFF",
 		);
 	}
 can_ok($mirror, "CompareDirectories");
 can_ok($mirror, "UpdateLocalFromRemote");
 can_ok($mirror, "UpdateRemoteFromLocal");
# thies tests need a network connection and a ftp-useraccount
# ok($mirror->CompareDirectories());
# ok($mirror->UpdateLocalFromRemote());
# ok($mirror->UpdateRemoteFromLocal());
 can_ok($mirror, "CheckEntryValues");
 ok($mirror->CheckEntryValues());
 can_ok($mirror, "InsertLocalTree");
 can_ok($mirror, "InsertRemoteTree");
 can_ok($mirror, "InsertLocalModified");
 can_ok($mirror, "InsertRemoteModified");
 can_ok($mirror, "UpdateAccess");
 ok($mirror->UpdateAccess("localdir", undef, "Homepage"));
 can_ok($mirror, "StoreNewAccess");
 ok($mirror->StoreNewAccess());
 can_ok($mirror, "InsertStoredValues");
 ok($mirror->InsertStoredValues());
 isa_ok($mirror->{upload}, "Net::MirrorDir");
 isa_ok($mirror->{download}, "Net::MirrorDir");
 isa_ok($mirror->{upload}, "Net::UploadMirror");
 isa_ok($mirror->{download}, "Net::DownloadMirror");
 for(qw/
 	new
 	ReadLocalDir
 	ReadRemoteDir
 	Connect
 	Quit
 	RemoteNotInLocal
 	LocalNotInRemote
 	CheckIfModified
 	StoreFiles
 	DeleteFiles
 	MakeDirs
 	RemoveDirs
 	Update
 	/)
 	{
 	can_ok($mirror->{upload}, $_);
 	can_ok($mirror->{download}, $_);
 	}
 ok(($mirror->{ref_h_local_files}, $mirror->{ref_h_local_dirs}) = 
 	$mirror->{upload}->ReadLocalDir());
 ok($mirror->InsertLocalTree());
 ok(($mirror->{ref_h_remote_files}, $mirror->{ref_h_remote_dirs}) =
 	$mirror->{download}->ReadLocalDir());
 ok($mirror->InsertRemoteTree());
 $mirror->{ref_a_modified_local_files}[0] = "TestA/TestB/TestC/Dir2/test2.txt";
 ok($mirror->InsertLocalModified());
 $mirror->{ref_a_modified_remote_files}[0] = "TestA/TestB/TestC/Dir4/test4.txt";
 ok($mirror->InsertRemoteModified());
 can_ok($mirror, "UpdateUsr");
 ok($mirror->UpdateUsr());

 $mirror->{para}{usr} = undef;
 is($mirror->UpdateUsr(), 0, "wrong user input\n");
 $mirror->{para}{usr} = "my_ftp_username";

 $mirror->{para}{ftpserver} = undef;
 is($mirror->UpdateUsr(), 0, "wrong ftp-server input\n");
 $mirror->{para}{ftpserver} = "my_ftp_server";

 $mirror->{para}{pass} = undef;
 is($mirror->UpdateUsr(), 0, "wrong password input\n");
 $mirror->{para}{pass} = "xyz";

 $mirror->{para}{localdir} = "WrongDir";
 is($mirror->UpdateUsr(), 0, "wrong dir should not exists\n");
 $mirror->{para}{localdir} = "TestA";
 is($mirror->UpdateUsr(), 1, "TestA should exists\n");

 $mirror->{para}{remotedir} = undef;
 is($mirror->UpdateUsr(), 0, "wrong remote direction input\n");
 $mirror->{para}{remotedir} = '/';
 is($mirror->UpdateUsr(), 1, "something is wrong with the user input\n");

 can_ok($mw, "after");
 ok($mw->after(3000, sub { $mw->destroy(); }));
 MainLoop(); 
#-------------------------------------------------






