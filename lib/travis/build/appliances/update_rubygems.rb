require 'travis/build/appliances/base'

module Travis
  module Build
    module Appliances
      class UpdateRubygems < Base
        RUBYGEMS_BASELINE_VERSION='2.6.13'
        def apply
          sh.file '${TRAVIS_HOME}/.rvm/hooks/after_use', <<~RVMHOOK
            #!/bin/bash
            gem --help &>/dev/null || return 0

            #{bash('travis_vers2int')}

            if [[ "$(travis_vers2int "$(gem --version)")" -lt "$(travis_vers2int "#{RUBYGEMS_BASELINE_VERSION}")" ]]; then
              echo ""
              echo -e "\\033[32;1m** Updating RubyGems to the latest version for security reasons. **\\033[0m"
              echo -e "\\033[32;1m** If you need an older version, you can downgrade with 'gem update --system OLD_VERSION'. **\\033[0m"
              echo ""
              gem update --system &>/dev/null
            fi
          RVMHOOK

          sh.cmd 'chmod +x ${TRAVIS_HOME}/.rvm/hooks/after_use'
        end
      end
    end
  end
end
