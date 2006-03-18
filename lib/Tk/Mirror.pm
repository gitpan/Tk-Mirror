#*** Mirror.pm ***#
# Copyright (C) Torsten Knorr
# create-soft@tiscali.de
# All rights reserved!
#-------------------------------------------------
 package Tk::Mirror;
#-------------------------------------------------
 use strict;
 use warnings;
 use Tk::Frame;
 use Net::UploadMirror;
 use Net::DownloadMirror;
 use Storable;
#-------------------------------------------------
 @Tk::Mirror::ISA = qw(Tk::Frame);
 $Tk::Mirror::VERSION = '0.02';
#-------------------------------------------------
 Construct Tk::Widget "Mirror";
#-------------------------------------------------
 sub Populate
 	{
 	require Tk::Label;
 	require Tk::Entry;
 	require Tk::BrowseEntry;
 	require Tk::Tree;
 	require Tk::Button;
 	my ($m, $args) = @_;
#-------------------------------------------------
=head
=item options
 	-localdir
 	-remotedir
 	-ftpserver
 	-usr
 	-pass
 	-debug
 	-timeout
 	-delete
 	-connection
 	-exclusions	
=cut
 	if(-f "para")
 		{
 		$m->{para} = retrieve("para");
 		}
 	else
 		{
 		$m->{para} = {};
 		}

 	$m->{para}{localdir}	= (defined($args->{-localdir}))	?
 		(delete($args->{-localdir}))				: 
 		($m->{para}{localdir}				|| '.');

 	$m->{para}{remotedir}	= (defined($args->{-remotedir}))	?
 		(delete($args->{-remotedir}))			: 
 		($m->{para}{remotedir}				|| '/');

 	$m->{para}{ftpserver}	= (defined($args->{-ftpserver}))	? 
 		(delete($args->{-ftpserver}))			: 
 		($m->{para}{ftpserver}				|| undef);

 	$m->{para}{usr}	= (defined($args->{-usr}))			?
 		(delete($args->{-usr}))				: 
 		($m->{para}{usr}					|| undef);

 	$m->{para}{pass}	= (defined($args->{-pass}))			?
 		(delete($args->{-pass}))				: 
 		($m->{para}{pass}					|| undef);

 	$m->{para}{debug}	= (defined($args->{-debug}))	?
 		(delete($args->{-debug}))				: 
 		($m->{para}{debug}				|| 1);

 	$m->{para}{timeout}	= (defined($args->{-timeout}))	?
 		(delete($args->{-timeout}))				: 
 		($m->{para}{timeout}				|| 30);

 	$m->{para}{delete}	= (defined($args->{-delete}))	?
 		(delete($args->{-delete}))				: 
 		($m->{para}{delete}				|| "disabled");

 	$m->{para}{connection}	= (defined($args->{-connection}))	?
 		(delete($args->{-connection}))			: 
 		($m->{para}{connection}				|| undef);

 	$m->{para}{exclusions}	= (defined($args->{-exclusions}))	?
 		(delete($args->{-exclusions}))			: 
 		($m->{para}{exclusions}				|| []);

 	$m->{upload} = Net::UploadMirror->new(%{$m->{para}});
 	$m->{download} = Net::DownloadMirror->new(%{$m->{para}});
 	$m->SUPER::Populate($args);
#-------------------------------------------------
 	my $label_usr	= $m->Label(
 		-text		=> "Username ->",
 		)->grid(
 		-row		=> 0,
 		-column		=> 0,
 		-columnspan	=> 3,
 		-sticky		=> "nswe",
 		);
#-------------------------------------------------
 	$m->{bentry_usr}	= $m->BrowseEntry(
 		-variable		=> \$m->{para}{usr},
 		-browsecmd	=> [\&UpdateAccess, $m, "usr"],
 		)->grid(
 		-row		=> 0,
 		-column		=> 3,
 		-columnspan	=> 3,
 		-sticky		=> "nswe",
 		);
#-------------------------------------------------
	my $label_ftpserver = $m->Label(
 		-text		=> "FTP-Server ->",
 		)->grid(
 		-row		=> 1,
 		-column		=> 0,
 		-columnspan	=> 3,
 		-sticky		=> "nswe",
 		);
#-------------------------------------------------
 	$m->{bentry_ftpserver} = $m->BrowseEntry(
 		-variable		=> \$m->{para}{ftpserver},
 		-browsecmd	=> [\&UpdateAccess, $m, "ftpserver"],
 		)->grid(
 		-row		=> 1,
 		-column		=> 3,
 		-columnspan	=> 3,
 		-sticky		=> "nsew",
 		);
#-------------------------------------------------
 	my $label_pass	= $m->Label(
 		-text		=> "Password ->",
 		)->grid(
 		-row		=> 2,
 		-column		=> 0,
 		-columnspan	=> 3,
 		-sticky		=> "nsew",
 		);
#-------------------------------------------------
 	$m->{entry_pass} = $m->Entry(
 		-textvariable	=> \$m->{para}{pass},
 		-show		=> '*',
 		)->grid(
 		-row		=> 2,
 		-column		=> 3,
 		-columnspan	=> 3,
 		-sticky		=> "nsew",
 		);
#-------------------------------------------------
 	my $label_local_dir = $m->Label(
 		-text		=> "Localdirectory",
 		)->grid(
 		-row		=> 3,
 		-column		=> 0,
 		-columnspan	=> 3,
 		-sticky		=> "nswe",
 		);
#-------------------------------------------------
 	my $label_remote_dir = $m->Label(
 		-text		=> "Remotedirectory",
 		)->grid(
 		-row		=> 3,
 		-column		=> 3,
 		-columnspan	=> 3,
 		-sticky		=> "nswe",
 		);
#-------------------------------------------------
 	$m->{bentry_local_dir} = $m->BrowseEntry(
 		-variable		=> \$m->{para}{localdir},
 		-browsecmd	=> [\&UpdateAccess, $m, "localdir"],
 		)->grid(
 		-row		=> 4,
 		-column		=> 0,
 		-columnspan	=> 3,
 		-sticky		=> "nswe",
 		);
#-------------------------------------------------
 	$m->{bentry_remote_dir} = $m->BrowseEntry(
 		-variable		=> \$m->{para}{remotedir},
 		-browsecmd	=> [\&UpdateAccess, $m, "remotedir"],
 		)->grid(
 		-row		=> 4,
 		-column		=> 3,
 		-columnspan	=> 3,
 		-sticky		=> "nswe",
 		);
#-------------------------------------------------
 	$m->{tree_local_dir} = $m->Scrolled(
 		"Tree",
 		-separator	=> "/",
 		-itemtype	=> "text",
 		-selectmode	=> "single",
 		)->grid(
 		-row		=> 5,
 		-column		=> 0,
 		-columnspan	=> 3,
 		-sticky		=> "nswe",
 		);
#-------------------------------------------------
 	$m->{tree_remote_dir} = $m->Scrolled(
 		"Tree",
 		-separator	=> "/",
 		-itemtype	=> "text",
 		-selectmode	=> "single",
 		)->grid(
 		-row		=> 5,
 		-column		=> 3,
 		-columnspan	=> 3,
 		-sticky		=> "nswe",
 		);
#-------------------------------------------------
 	$m->{button_update_up} = $m->Button(
 		-text		=> "Update Remote from Local ->",
 		-command	=> [\&UpdateRemoteFromLocal, $m],
 		-state		=> "disabled",
 		)->grid(
 		-row		=> 6,
 		-column		=> 0,
 		-columnspan	=> 2,
 		-sticky		=> "nswe",
 		);
#-------------------------------------------------
 	$m->{button_compare} = $m->Button(
 		-text		=> "Compare",
 		-command	=> [\&CompareDirectories, $m],
 		-state		=> "disabled",
 		)->grid(
 		-row		=> 6,
 		-column		=> 2,
 		-columnspan	=> 2,
 		-sticky		=> "nsew",
 		);
#-------------------------------------------------
 	$m->{button_update_down} = $m->Button(
 		-text		=> "<- Update Local from Remote",
 		-command	=> [\&UpdateLocalFromRemote, $m],
 		-state		=> "disabled",
 		)->grid(
 		-row		=> 6,
 		-column		=> 4,
 		-columnspan	=> 2,
 		-sticky		=> "nswe",
 		);
#-------------------------------------------------
 	$m->{childs} = {
 		"LabelUsr"		=> $label_usr,
 		"bEntryUsr"		=> $m->{bentry_usr},
 		"LabelFtpServer"		=> $label_ftpserver,
 		"bEntryFtpServer"		=> $m->{bentry_ftpserver},
 		"LabelPass"		=> $label_pass,
 		"EntryPass"		=> $m->{entry_pass},
 		"LabelLocalDir"		=> $label_local_dir,
 		"LabelRemoteDir"		=> $label_remote_dir,
 		"bEntryLocalDir"		=> $m->{bentry_local_dir},
 		"bEntryRemoteDir"	=> $m->{bentry_remote_dir},
 		"TreeLocalDir"		=> $m->{tree_local_dir},
 		"TreeRemoteDir"		=> $m->{tree_remote_dir},
 		"ButtonUpdateUp"	=> $m->{button_update_up},
 		"ButtonCompare"		=> $m->{button_compare},
 		"ButtonUpdateDown"	=> $m->{button_update_down},
 		};
 	$m->Advertise($_ => $m->{childs}{$_}) for(keys(%{$m->{childs}})); 
 	$m->Delegates(
 		DEFAULT	=> $m->{tree_local_dir},
 		);	
 	$m->{bentry_usr}->bind("<KeyRelease>", sub { $m->CheckEntryValues(); });
 	$m->{entry_pass}->bind("<KeyRelease>", sub { $m->CheckEntryValues(); });
 	$m->{bentry_ftpserver}->bind("<KeyRelease>", sub { $m->CheckEntryValues(); });
 	$m->InsertStoredValues();
 	}
#-------------------------------------------------
 sub DESTROY
 	{
 	my ($self) = @_;
 	store($self->{para}, "para");
 	if($self->{_debug})
 		{
 		my $class = ref($self);
 		print("$class object destroyed\n");
 		} 
 	}
#-------------------------------------------------
 sub CheckEntryValues
 	{
 	if($_[0]->{para}{usr} && $_[0]->{para}{pass} && $_[0]->{para}{ftpserver})
 		{
 		$_[0]->{button_compare}->configure(
 			-state		=> "normal",
 			);
 		}
 	else
 		{
 		$_[0]->{button_compare}->configure(
 			-state		=> "disabled",
 			);
 		}
 	return 1;
 	}
#-------------------------------------------------
 sub GetChilds
 	{
 	return $_[0]->{childs};
 	}
#-------------------------------------------------
 sub UpdateUsr
  	{
  	my ($self) = @_;
# TO DO we need some better user input checks!!!
  	return 0 if(!(defined($self->{para}{usr})));
  	return 0 if(!(defined($self->{para}{ftpserver})));
  	return 0 if(!(defined($self->{para}{pass})));
  	return 0 if(!(defined($self->{para}{localdir})));
  	return 0 if(!(-d $self->{para}{localdir}));
  	return 0 if(!(defined($self->{para}{remotedir})));
  	
  	return 0 if(!($self->{upload}->SetUsr($self->{para}{usr})));
  	return 0 if(!($self->{upload}->SetFtpServer($self->{para}{ftpserver})));
  	return 0 if(!($self->{upload}->SetPass($self->{para}{pass})));
  	return 0 if(!($self->{upload}->SetLocalDir($self->{para}{localdir})));
  	return 0 if(!($self->{upload}->SetRemoteDir($self->{para}{remotedir})));
  	
 	return 0 if(!($self->{download}->SetUsr($self->{para}{usr})));
 	return 0 if(!($self->{download}->SetFtpServer($self->{para}{ftpserver})));
 	return 0 if(!($self->{download}->SetPass($self->{para}{pass})));
 	return 0 if(!($self->{download}->SetLocalDir($self->{para}{localdir})));
 	return 0 if(!($self->{download}->SetRemoteDir($self->{para}{remotedir})));
 	return 1;
 	}
#-------------------------------------------------
 sub CompareDirectories
 	{
 	my ($self) = @_;
 	return if(!($self->UpdateUsr()));
 	$self->{upload}->Connect() if(!(defined($self->{upload}->GetConnection())));
 	return if(!(defined($self->{upload}->GetConnection())));
 	$self->StoreNewAccess();
 	($self->{ref_h_local_files}, $self->{ref_h_local_dirs}) =
 		$self->{upload}->ReadLocalDir();
 	if($self->{upload}->GetDebug())
 		{
 		print("local files : $_\n") for(sort keys %{$self->{ref_h_local_files}});
 		print("local dirs : $_\n") for(sort keys %{$self->{ref_h_local_dirs}});
 		}
 	($self->{ref_h_remote_files}, $self->{ref_h_remote_dirs}) =
 		$self->{upload}->ReadRemoteDir();
 	if($self->{upload}->GetDebug())
 		{
 		print("remote files : $_\n") for(sort keys %{$self->{ref_h_remote_files}});
 		print("remote dirs : $_\n") for(sort keys %{$self->{ref_h_remote_dirs}});
 		};
 	$self->{ref_a_new_remote_files} = $self->{upload}->RemoteNotInLocal(
 		$self->{ref_h_local_files}, $self->{ref_h_remote_files});
 	if($self->{upload}->GetDebug())
 		{
 		print("new remote files : $_\n") for(@{$self->{ref_a_new_remote_files}});
 		}
 	$self->{ref_a_new_remote_dirs} = $self->{upload}->RemoteNotInLocal(
 		$self->{ref_h_local_dirs}, $self->{ref_h_remote_dirs});
 	if($self->{upload}->GetDebug())
 		{
 		print("new remote dirs : $_\n") for(@{$self->{ref_a_new_remote_dirs}});
 		}
 	$self->{ref_a_new_local_files} = $self->{upload}->LocalNotInRemote(
 		$self->{ref_h_local_files}, $self->{ref_h_remote_files});
 	if($self->{upload}->GetDebug())
 		{
 		print("new local files : $_\n") for(@{$self->{ref_a_new_local_files}});
 		}
 	$self->{ref_a_new_local_dirs} = $self->{upload}->LocalNotInRemote(
 		$self->{ref_h_local_dirs}, $self->{ref_h_remote_dirs});
 	if($self->{upload}->GetDebug())
 		{
 		print("new local dirs : $_\n") for(@{$self->{ref_a_new_local_dirs}});
 		}
 	$self->InsertLocalTree();
 	$self->InsertRemoteTree();
 	delete($self->{ref_h_local_files}->{$_}) for(@{$self->{ref_a_new_local_files}});
 	$self->{ref_a_modified_local_files} = $self->{upload}->CheckIfModified(
 		$self->{ref_h_local_files});
 	if($self->{upload}->GetDebug())
 		{
 		print("modified local files : $_\n") for(@{$self->{ref_a_modified_local_files}});
 		}
 	$self->InsertLocalModified();
 	$self->{download}->SetConnection($self->{upload}->GetConnection());
 	delete($self->{ref_h_remote_files}->{$_}) for(@{$self->{ref_a_new_remote_files}});
 	$self->{ref_a_modified_remote_files} = $self->{download}->CheckIfModified(
 		$self->{ref_h_remote_files});
 	if($self->{upload}->GetDebug())
 		{
 		print("modified remote files : $_\n") for(@{$self->{ref_a_modified_remote_files}});
 		}
 	$self->InsertRemoteModified();
 	$self->{upload}->Quit();
 	$self->{download}->SetConnection(undef);
 	$self->{button_update_up}->configure(
 		-state		=> "normal",
 		);
 	$self->{button_update_down}->configure(
 		-state		=> "normal",
 		);
 	return 1;
 	}
#-------------------------------------------------
 sub InsertLocalTree
 	{
 	my ($self) = @_;
 	$self->{tree_local_dir}->delete("all");
 	for(keys(%{$self->{ref_h_local_dirs}}), keys(%{$self->{ref_h_local_files}}))
 		{
 		my $p;
 		my $path = $_;
 		$path =~ s!^/+!!;
 		for(split('/', $path)) 
 			{
 			$p .= $_;
 			if(!($self->{tree_local_dir}->info("exists", $p)))
 				{
				$self->{tree_local_dir}->add(
 					$p,
 					-text		=> $_,
 					);
 				}
 			$p .= '/';
 			}
 		}
 	$self->{tree_local_dir}->autosetmode();
 	for(@{$self->{ref_a_new_local_dirs}}, @{$self->{ref_a_new_local_files}})
 		{
 		my $path = $_;
 		$path =~ s!^/+!!;
 		$self->{tree_local_dir}->entryconfigure(
 			$path,
 			-text	=> (split('/', $path))[-1] . "<not in remote dir>",
 			);
 		}
 	return 1;
  	}
#-------------------------------------------------
 sub InsertLocalModified
 	{
 	my ($self) = @_;
 	for(@{$self->{ref_a_modified_local_files}})
 		{
 		my $path = $_;
 		$path =~ s!^/+!!;
 		$self->{tree_local_dir}->entryconfigure(
 			$path,
 			-text	=> (split('/', $path))[-1] . "<modified>",
 			);
 		}
 	return 1;
 	}
#-------------------------------------------------
 sub InsertRemoteTree
 	{
 	my ($self) = @_;
 	$self->{tree_remote_dir}->delete("all");
 	for(keys(%{$self->{ref_h_remote_dirs}}), keys(%{$self->{ref_h_remote_files}}))
 		{
 		my $p;
 		my $path = $_;
 		$path =~ s!^/+!!;
 		for(split('/', $path)) 
 			{
 			$p .= $_;
 			if(!($self->{tree_remote_dir}->info("exists", $p)))
 				{
				$self->{tree_remote_dir}->add(
 					$p,
 					-text		=> $_,
 					);
 				}
 			$p .= '/';
 			}
 		}
 	$self->{tree_remote_dir}->autosetmode();
 	for(@{$self->{ref_a_new_remote_dirs}}, @{$self->{ref_a_new_remote_files}})
 		{
 		my $path = $_;
 		$path =~ s!^/+!!;
 		$self->{tree_remote_dir}->entryconfigure(
 			$path,
 			-text	=> (split('/', $path))[-1] . "<not in local dir>",
 			);
 		}
 	return 1;
 	}
#-------------------------------------------------
 sub InsertRemoteModified
 	{
 	my ($self) = @_;
 	for(@{$self->{ref_a_modified_remote_files}})
 		{
 		my $path = $_;
 		$path =~ s!^/+!!;
 		$self->{tree_remote_dir}->entryconfigure(
 			$path,
 			-text	=> (split('/', $path))[-1] . "<modified>",
 			);
 		}
 	return 1;
 	}
#-------------------------------------------------
 sub UpdateLocalFromRemote
 	{
 	my ($self) = @_;
 	$self->{download}->MakeDirs($self->{ref_a_new_remote_dirs});
 	return if(!($self->UpdateUsr()));
 	$self->{download}->Connect() if(!(defined($self->{download}->GetConnection())));
 	if(defined($self->{download}->GetConnection()))
 		{
 		$self->{download}->StoreFiles($self->{ref_a_new_remote_files});
 		$self->{download}->StoreFiles($self->{ref_a_modified_remote_files});
 		$self->{download}->Quit();
 		}
 	if($self->{download}->GetDelete())
 		{
 		$self->{download}->DeleteFiles($self->{ref_a_new_local_files});
 		$self->{download}->RemoveDirs($self->{ref_a_new_local_dirs});
 		}
 	$self->CompareDirectories();
 	return 1;
 	}
#-------------------------------------------------
 sub UpdateRemoteFromLocal
 	{
 	my ($self) = @_;
 	return if(!($self->UpdateUsr()));
 	$self->{upload}->Connect() if(!(defined($self->{upload}->GetConnection())));
 	return if(!(defined($self->{upload}->GetConnection())));
 	$self->{upload}->MakeDirs($self->{ref_a_new_local_dirs});
 	$self->{upload}->StoreFiles($self->{ref_a_new_local_files});
 	$self->{upload}->StoreFiles($self->{ref_a_modified_local_files});
 	if($self->{upload}->GetDelete())
 		{
 		$self->{upload}->DeleteFiles($self->{ref_a_new_remote_files});
 		$self->{upload}->RemoveDirs($self->{ref_a_new_remote_dirs});
 		}
 	$self->CompareDirectories();
 	return 1;
 	}
#-------------------------------------------------
# $self->{para}{access}{<attr><value>} = [usr, ftpserver, pass, localdir, remotedir];
#-------------------------------------------------
 sub UpdateAccess
 	{
 	my ($self, $attr, $bentry, $value) = @_;
 	my $key = "<$attr><$value>";
 	if(defined($self->{para}{access}{$key}))
 		{
 		$self->{para}{usr}		= $self->{para}{access}{$key}[0];
 		$self->{para}{ftpserver}	= $self->{para}{access}{$key}[1];
 		$self->{para}{pass}	= $self->{para}{access}{$key}[2];
 		$self->{para}{localdir}	= $self->{para}{access}{$key}[3];
 		$self->{para}{remotedir}	= $self->{para}{access}{$key}[4];
 		}
 	return 1;
 	}
#-------------------------------------------------
 sub StoreNewAccess
 	{
 	my ($self) = @_;
 	my $ref_a_values = [
 		$self->{para}{usr}, 
 		$self->{para}{ftpserver},
 		$self->{para}{pass},
 		$self->{para}{localdir},
 		$self->{para}{remotedir},
 		];
 	for(qw/usr ftpserver pass localdir remotedir/)
 		{
 		$self->{para}{access}{"<$_><$self->{para}{$_}>"} = $ref_a_values;
 		}
 	return 1;
 	}
#-------------------------------------------------
 sub InsertStoredValues
 	{
 	my ($self) = @_;
 	if($self->{para}{usr} && $self->{para}{pass} && $self->{para}{ftpserver})
 		{
 		$self->{button_compare}->configure(
 			-state		=> "normal",
 			);
 		}
	for(keys(%{$self->{para}{access}}))
 		{
 		SWITCH:
 			{
 			m/<usr><(.+)>/		&& do
 				{
 				$self->{bentry_usr}->insert("end", $1);
 				last SWITCH;
 				};
 			m/<ftpserver><(.+)>/	&& do 
 				{
 				$self->{bentry_ftpserver}->insert("end", $1);
 				last SWITCH;
 				};
 			m/<localdir><(.+)>/	&& do
 				{
 				$self->{bentry_local_dir}->insert("end", $1);
 				last SWITCH;
 				};
 			m/<remotedir><(.+)>/	&& do
 				{
				$self->{bentry_remote_dir}->insert("end", $1);
 				last SWITCH;
 				};
 			}
 		} 
 	return 1;
 	}
#------------------------------------------------- 
1;
#-------------------------------------------------
__END__

=head1 NAME

Tk::Mirror - Perl extension for a graphic user interface to update local or remote directories in both directions

=head1 SYNOPSIS

# in the simplest kind and manner

 use Tk::Mirror;
 use Tk;
 my $mw->MainWindow->new();
 $mw->Mirror()->grid();
 MainLoop();

# in a detailed kind

 use Tk;
 use Tk::Mirror;
 my $mw = MainWindow->new();
 my $mirror = $mw->Mirror(
	-localdir		=> "TestA",
	-remotedir	=> "TestD",
	-usr		=> 'my_ftp@username.de'
	-ftpserver	=> "ftp.server.de",
	-pass		=> "my_password",
 	-debug		=> 1,
 	-delete		=> "enable",
 	-exclusions	=> ["private.txt", "secret.txt"],
 	-timeout		=> 60,
 	-connection	=> undef, # or a connection  to a ftp-server 
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
 MainLoop();
 
=head1 DESCRIPTION

This is a graphic user interface to compare and update local with remote 
directories in both directions.

=head1 CONSTRUCTOR and INITIALIZATION

=item (widget-Mirror-object) MainWindow-object->Mirror (options)

=item ftpserver
the hostname of the ftp-server

=item usr	
the username for authentification

=item pass
password for authentification

=item localdir
local directory selecting information from, default '.'

=item remotedir
remote location selecting information from, default '/' 

=item debug
set it true for more information about the ftp-process, default 1 

=item timeout
the timeout for the ftp-serverconnection

=item delete
set this to "enable" to allow the deletion of files, default "disabled" 

=item connection
takes a Net::FTP-object you should not use that, default undef

=item exclusions
a reference to a list of strings interpreted as regular-expressios ("regex") 
matching to something in the local pathnames, you do not want to list, 
default empty list [ ]
 
=head2 METHODS

=item (ref_h_all_childs) mirror-object->GetChilds (void)
returns a hash of all childs used in the put-together widget,
on you can call the "configure" function.

 KEYS			VALUES
 "LabelUsr"		=> $label_usr,
 "bEntryUsr"		=> $m->{bentry_usr},
 "LabelFtpServer"		=> $label_ftpserver,
 "bEntryFtpServer"	=> $m->{bentry_ftpserver},
 "LabelPass"		=> $label_pass,
 "EntryPass"		=> $m->{entry_pass},
 "LabelLocalDir"		=> $label_local_dir,
 "LabelRemoteDir"		=> $label_remote_dir,
 "bEntryLocalDir"		=> $m->{bentry_local_dir},
 "bEntryRemoteDir"	=> $m->{bentry_remote_dir},
 "TreeLocalDir"		=> $m->{tree_local_dir},
 "TreeRemoteDir"		=> $m->{tree_remote_dir},
 "ButtonUpdateUp"	=> $m->{button_update_up},
 "ButtonCompare"		=> $m->{button_compare},
 "ButtonUpdateDown"	=> $m->{button_update_down},

=item (ref_of_child) mirror-object->Subwidget(above shown key)
returns a reference of a child widget you can call the configure
method

=head2 EXPORT

None by default.

=head1 SEE ALSO

 Tk
 Net::MirrorDir
 Net::UploadMirror
 Net::DownloadMirror
 http://www.planet-interkom.de/t.knorr/index.html

=head1 BUGS

Maybe you'll find some. Let me know.

=head1 AUTHOR

Torsten Knorr, E<lt>torstenknorr@tiscali.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Torsten Knorr

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.9.2 or,
at your option, any later version of Perl 5 you may have available.


=cut








