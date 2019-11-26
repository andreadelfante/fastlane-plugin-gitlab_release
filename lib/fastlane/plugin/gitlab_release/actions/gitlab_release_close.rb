require 'fastlane/action'
require_relative '../helper/gitlab_release_helper'

require 'gitlab/release/changelog/entries'

module Fastlane
  module Actions
    class GitlabReleaseCloseAction < Action
      def self.run(params)
        require 'gitlab/release/manager'

        endpoint = params[:endpoint] || ENV["GITLAB_API_ENDPOINT"] || ENV["CI_API_V4_URL"]
        private_token = params[:private_token] || ENV["GITLAB_API_PRIVATE_TOKEN"]
        version_name = params[:version_name]
        entries = params[:entries]
        tag_name = params[:tag_name] || version_name
        project_id = params[:project_id] || ENV["CI_PROJECT_ID"]
        ref = params[:ref] || ENV["CI_COMMIT_SHA"]

        manager = Gitlab::Release::Manager.new(endpoint, private_token)

        UI.message("Closing all milestones related to version '#{version_name}'")
        manager.close_milestones(version_name,
                                 project_id: project_id)
        UI.success("All milestones related to version '#{version_name}' are closed now!")

        UI.message("Defining tag '#{tag_name}' in '#{ref}'")
        manager.define_tag(tag_name,
                           entries.to_s_with_reference(true),
                           project_id: project_id,
                           ref: ref)
        UI.success("Defined tag '#{tag_name}' with changelog successfully!")
      end

      def self.description
        "Create a tag with release note and close milestones"
      end

      def self.details
        "This action create a tag containing release note and close the associated milestones"
      end

      def self.authors
        ["Andrea Del Fante"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :endpoint,
                                       env_name: "GITLAB_API_ENDPOINT",
                                       description: "API endpoint URL, default: ENV['GITLAB_API_ENDPOINT'] and falls back to ENV['CI_API_V4_URL']",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :private_token,
                                       env_name: "GITLAB_API_PRIVATE_TOKEN",
                                       description: "user's private token or OAuth2 access token",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :version_name,
                                       description: "The version name to generate the changelog",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :entries,
                                       description: "The generated changelog to include",
                                       optional: false,
                                       type: Gitlab::Release::Changelog::Entries),
          FastlaneCore::ConfigItem.new(key: :tag_name,
                                       description: "The tag name to use in the creating tag. Default: version_name",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :project_id,
                                       env_name: "CI_PROJECT_ID",
                                       description: "The id of this project",
                                       optional: true,
                                       is_string: false,
                                       verify_block: proc do |value|
                                         case value
                                         when String, Integer
                                           @project_id = value
                                         else
                                           UI.user_error!("The project_id must be a String or Integer value.")
                                         end
                                       end),
          FastlaneCore::ConfigItem.new(key: :ref,
                                       env_name: "CI_COMMIT_SHA",
                                       description: "The ref to tag with tag_name. default: ENV['CI_COMMIT_SHA']",
                                       optional: true,
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
