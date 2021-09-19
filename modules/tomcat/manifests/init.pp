class tomcat{

exec {'executing command':
command => "apt-get update",
path => '/usr/bin',
before => Package['installing java']
}
package {'installing java':
name => default-jdk,
ensure => present,
before => Group['tomcat user']
}
group {'tomcat user':
name => tomcat,
ensure => present,
before => File['creating directory']
}
file {'creating directory':
ensure => directory,
path => '/opt/tomcat',
before => File['ttd']
}
file {'ttd':
path => '/opt/tomcat/apache-tomcat-9.0.53.tar.gz',
ensure => directory,
source => "puppet:///modules/tomcat/apache-tomcat-9.0.53.tar.gz",
before => Exec['untar']
}
exec {'untar':
command => '/bin/tar --extract --file apache-tomcat-9.0.53.tar.gz',
cwd => '/opt/tomcat/',
before => Exec['adding user']
}
exec {'adding user':
command => "sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat",
path => '/usr/bin',
before => Exec['sudo commands']
}
exec {'sudo commands':
command => 'sudo chmod -R g+r conf',
cwd => '/opt/tomcat/apache-tomcat-9.0.53',
path => '/usr/bin',
before => Exec['sudo commands3']
}
exec {'sudo commands3':
command => 'sudo chgrp -R tomcat /opt/tomcat',
cwd => '/opt/tomcat/',
path => '/usr/bin',
before => Exec['sudo commands2']
}
exec {'sudo commands2':
command => 'sudo chown -R tomcat webapps/ work temp/ logs',
cwd => '/opt/tomcat/apache-tomcat-9.0.53',
path => '/usr/bin',
before => File['/etc/systemd/system/tomcat.service']
}
file {'/etc/systemd/system/tomcat.service':
source => 'puppet:///modules/tomcat/tomcat.service',
ensure => present
}
}
