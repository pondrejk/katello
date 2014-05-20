#
# Copyright 2014 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

module Actions
  module Katello
    module CapsuleContent
      class AddRepository < ::Actions::EntryAction

        def plan(capsule_content, repository)
          distributor = repository.find_node_distributor
          unless distributor
            fail "Could not find node distributor for repository %s" % repository.pulp_id
          end

          plan_action(Pulp::Consumer::BindDistributor,
                      uuid: capsule_content.consumer_uuid,
                      repo_id: repository.pulp_id,
                      distributor_id: distributor['id'],
                      bind_options: bind_options)
        end

        private

        def bind_options
          { notify_agent: false, binding_config: { strategy: 'mirror' } }
        end

      end
    end
  end
end
