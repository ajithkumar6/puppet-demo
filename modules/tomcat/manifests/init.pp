class tomcat{

exec {'executing command':
command => "apt-get update",
path => '/usr/bin',
before => Package['installing java']
}
package {'installing java':
name => default-jdk,
ensure => present,
before => Group['tomcat']
}
group {'tomcat':
ensure => present,
before => File['creating directory']
}
file {'creating directory':
ensure => directory,
path => '/opt/tomcat',
before => Exec['adding user']
}
exec {'adding user':
command => "sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat",
cwd => '/opt/tomcat',
path => '/usr/bin',
before => File['/tmp/tomcat/']
}
file {'/tmp/tomcat/':
ensure => present,
group => tomcat,
source => "puppet:///modules/tomcat/apache-tomcat-9.0.53.tar.gz",
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
