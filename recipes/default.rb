#
# Cookbook Name:: ampelserver
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

include_recipe 'git'
include_recipe 'build-essential'

package 'ruby1.9.1'
package 'rubygems'
package 'libxml2-dev'
package 'libxslt1-dev'
package 'sispmctl' # The tool to control the power bar

gem_package 'bundler'

directory '/var/apps'

deploy '/var/apps/ampelfreude' do
  repo 'git://github.com/betterplace/ampelfreude.git'
  revision 'master'
  [symlink_before_migrate, purge_before_symlink, create_dirs_before_symlink, symlinks].each(&:clear)

  before_restart do
    execute "bundle install --deployment" do
      cwd '/var/apps/ampelfreude/current'
    end
  end
end

cookbook_file '/etc/init/ampelfreude.conf' do
  source 'ampelfreude.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/etc/init/ampelfreude' do
  source 'ampelfreude'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'ampelfreude' do
  action [:start, :enable]
end