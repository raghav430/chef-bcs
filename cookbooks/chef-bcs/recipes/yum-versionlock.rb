#
# Author:: Chris Jones <cjones303@bloomberg.net>
# Cookbook Name:: chef-bcs
#
# Copyright 2016, Bloomberg Finance L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Call this recipe to add version locking for specific packages
#     "recipe[chef-bcs::yum-versionlock]"

node['chef-bcs']['repo']['packages'].each do | pkg |
  if pkg['pin']
    execute "#{pkg['name']}-add-versionlock" do
      command lazy { "yum versionlock add #{pkg['name']}" }
      not_if "yum versionlock list | grep #{pkg['name']}"
      ignore_failure true
    end
  else
    execute "#{pkg['name']}-delete-versionlock" do
      command lazy { "yum versionlock delete #{pkg['name']}" }
      only_if "yum versionlock list | grep #{pkg['name']}"
      ignore_failure true
    end
  end
end
