Exec  { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
File  { owner => 0, group => 0, mode => 0644 }
group { 'puppet': ensure => 'present' }

class    {'apt': always_apt_update => true,}
package  {'build-essential': ensure  => 'present',}
package  {'software-properties-common': ensure  => 'present',}
package  {'python-software-properties': ensure  => 'present',}
package  {'vim': ensure  => 'present',}
package  {'curl': ensure  => 'present',}
package  {'git-core': ensure  => 'present',}
class    {'puphpet::dotfiles':}
apt::ppa {'ppa:ondrej/php5-oldstable':}

file { [ "/etc/php5", "/etc/php5/apache2"]:
    ensure => "directory",
    mode   => 644,
}

file {'/etc/php5/apache2/php.ini':
  ensure  => present,
  mode   => 644,
}

class       {'php':}
class       {'apache': default_vhost => false}
apache::mod {'rewrite': }

include php::composer
include php::phpunit

class {
  'php::cli':
    ensure   => 'installed',
    provider => 'apt',
    settings => {
        set => {
          'PHP/short_open_tag'       => 'Off',
          'PHP/asp_tags'             => 'Off',
          'PHP/expose_php'           => 'Off',
          'PHP/memory_limit'         => '1024M',
          'PHP/display_errors'       => 'On',
          'PHP/log_errors'           => 'On',
          'PHP/post_max_size'        => '500M',
          'PHP/upload_max_filesize'  => '500M',
          'PHP/max_execution_time'   => 600,
          'PHP/allow_url_include'    => 'Off',
          'PHP/error_log'            => 'syslog',
          'PHP/output_buffering'     => 4096,
          'PHP/output_handler'       => 'Off',
          'Date/date.timezone'       => 'America/Sao_Paulo'
        }
    }
}

class {
  'php::apache':
    ensure   => 'installed',
    provider => 'apt',
    settings => {
        set => {
          'PHP/short_open_tag'       => 'Off',
          'PHP/asp_tags'             => 'Off',
          'PHP/expose_php'           => 'Off',
          'PHP/memory_limit'         => '1024M',
          'PHP/display_errors'       => 'On',
          'PHP/log_errors'           => 'On',
          'PHP/post_max_size'        => '500M',
          'PHP/upload_max_filesize'  => '500M',
          'PHP/max_execution_time'   => 600,
          'PHP/allow_url_include'    => 'Off',
          'PHP/error_log'            => 'syslog',
          'PHP/output_buffering'     => 4096,
          'PHP/output_handler'       => 'Off',
          'Date/date.timezone'       => 'America/Sao_Paulo'
        }
    },
    require => [Class['apache'], Class['php'], File['/etc/php5/apache2/php.ini']],
}

class {
  'php::dev':
    ensure   => 'installed',
    provider => 'apt',
}

class {
  'php::pear':
    ensure   => 'installed',
    provider => 'apt',
}

class {
  'php::extension::mysql':
    ensure   => 'installed',
    provider => 'apt',
}

class {
  'php::extension::curl':
    ensure   => 'installed',
    provider => 'apt',
}

class {
 'php::extension::intl':
    ensure   => 'installed',
    provider => 'apt',
}

class {
  'php::extension::mcrypt':
    ensure   => 'installed',
    provider => 'apt',
}

class {
  'php::extension::xdebug':
    ensure   => 'installed',
    provider => 'apt',
}

package { 'memcache':
    ensure   => installed,
    provider => pecl;
}

package { 'memcached':
    ensure   => installed,
    provider => pecl;
}

package { 'PDO_MYSQL':
    ensure   => installed,
    provider => pecl;
}

package { 'PDO_SQLITE':
    ensure   => installed,
    provider => pecl;
}

# Install PHPQaTools

class { 'mysql::server':
  config_hash   => {
    'root_password' => 'vagrant',
    'bind_address'  => '0.0.0.0',
  }
}

class { 'phpmyadmin':
  require => [Class['mysql::server'], Class['mysql::config'], Class['php']],
}

apache::vhost { 'default':
  vhost_name    => '*',
  port          => '80',
  default_vhost => true,
  docroot       => '/vagrant/public',
  aliases     => [ { alias => '/phpmyadmin', path => '/usr/share/phpmyadmin' } ],
  directories   => [
      {
        path => '/vagrant',
        allow_override => ['All'],
        options => ['Indexes','FollowSymLinks'],
        order => 'allow,deny',
      },
      {
        path => '/usr/share/phpmyadmin'
      }
  ],
}

database { 'vagrant':
  ensure  => 'present',
  charset => 'utf8',
  require => Class['mysql::server'],
}

database_user { 'root@%':
  password_hash => mysql_password('vagrant'),
  require => Class['mysql::server'],
}

database_grant { 'root@%':
  privileges => ['all'],
  require => Class['mysql::server'],
}
