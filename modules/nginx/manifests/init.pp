class nginx{
    $package_name   = hiera('packagename')
    $directory_path = hiera('directory_path')
    $file_path      = hiera('file_path')
    $index_source   = hiera('index_source')
    $index_path     = hiera('index_path')
    $nginx_source   = hiera('nginx_source')
    package {'package':
    name => $package_name,
    ensure => present,
    before => File['directory_path']
    }
    file {'directory_path':
    path => $directory_path,
    ensure => directory,
    require => Package['package']
    }
    file {'file_path':
    path => $file_path,
    ensure => file,
    source => $index_source,
    require => File['directory_path']
    }
    file {'index_path':
    path => $index_path,
    ensure => file,
    source => $nginx_source,
    require => File['file_path']
    }
    service {"package_name":
    name => $package_name,
    ensure => running,
    subscribe => [File['index_path'],File['file_path']]
    }

}
