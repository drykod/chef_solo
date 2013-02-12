#
# Cookbook Name:: chef-monitor
# Recipe:: base_checks
#
# Copyright 2013, Stephen Lum
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "chef-monitor::default"

%w[
	check-banner.rb
	check-disk.rb
	check-mem.sh
	load-metrics.rb
	metrics-netstat-tcp.rb
].each do |check|
	cookbook_file "/etc/sensu/plugins/#{check}" do
  	source "plugins/#{check}"
  	mode 0755
	end
end

sensu_check "check_disk" do
  command "check-disk.rb"
  handlers ["default"]
  subscribers ["all"]
  interval 30
end

sensu_check "check_mem" do
  command "check-mem.sh"
  handlers ["default"]
  subscribers ["all"]
  interval 30
end

sensu_check "load_metrics" do
  command "load-metrics.rb"
  handlers ["default"]
  subscribers ["all"]
  interval 30
end

sensu_check "check_ssh" do
  command "check-banner.rb -p 22223"
  handlers ["default"]
  subscribers ["all"]
  interval 30
end

sensu_check "metrics-netstat-tcp" do
  command "metrics-netstat-tcp.rb -p 22223"
  handlers ["default"]
  subscribers ["all"]
  interval 30
end