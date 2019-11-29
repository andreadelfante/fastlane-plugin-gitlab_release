require 'fastlane/action'
require_relative '../helper/gitlab_release_helper'

module Fastlane
  module Actions
    class GitlabReleaseChangelogAction < Action
      def self.run(params)
        require 'gitlab/release/changelog/generator'

        endpoint = params[:endpoint]
        private_token = params[:private_token]
        version_name = params[:version_name]
        project_id = params[:project_id]
        include_mrs = params[:include_mrs]
        include_issues = params[:include_issues]
        split_key = params[:split_key]
        filtering_labels = params[:filtering_labels]
        filtering_mrs_labels = params[:filtering_mrs_labels]
        filtering_issues_labels = params[:filtering_issues_labels]

        array_labels = filtering_labels.split(split_key) unless filtering_labels.empty?
        array_mrs_labels = filtering_mrs_labels.split(split_key) unless filtering_mrs_labels.empty?
        array_issues_labels = filtering_issues_labels.split(split_key) unless filtering_issues_labels.empty?

        changelog_generator = Gitlab::Release::Changelog::Generator.new(endpoint: endpoint,
                                                                        private_token: private_token)

        UI.message("Creating changelog for version '#{version_name}'.")
        changelog = changelog_generator.changelog(version_name,
                                                  project_id: project_id,
                                                  include_mrs: include_mrs,
                                                  include_issues: include_issues,
                                                  filtering_labels: array_labels,
                                                  filtering_mrs_labels: array_mrs_labels,
                                                  filtering_issues_labels: array_issues_labels)

        UI.success("Generated changelog for #{version_name} successfully!")
        changelog
      end

      def self.description
        "Generate the changelog of a specific version"
      end

      def self.details
        "This action generate the changelog from a specified version name."
      end

      def self.authors
        ["Andrea Del Fante"]
      end

      def self.return_value
        "Return a 'Entries' object containing changelogs"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :endpoint,
                                       env_name: "GITLAB_API_ENDPOINT",
                                       description: "The API endpoint URL, default: ENV['GITLAB_API_ENDPOINT'] and falls back to ENV['CI_API_V4_URL']",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :private_token,
                                       env_name: "GITLAB_API_PRIVATE_TOKEN",
                                       description: "User's private token or OAuth2 access token",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :version_name,
                                       description: "The name of the version. (ex: 1.0)",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :project_id,
                                       env_name: "CI_PROJECT_ID",
                                       description: "The id of this project, given from GitLab. Default ENV[\"CI_PROJECT_ID\"]",
                                       optional: true,
                                       is_string: false,
                                       verify_block: proc do |value|
                                         case value
                                         when String, Integer
                                           @project_id = value
                                         else
                                           UI.user_error!("The project_id must be a String or Integer value")
                                         end
                                       end),
          FastlaneCore::ConfigItem.new(key: :include_mrs,
                                       env_name: "GITLAB_RELEASE_INCLUDE_MRS",
                                       description: "Should the generator include merge requests?",
                                       optional: true,
                                       type: Boolean,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :include_issues,
                                       env_name: "GITLAB_RELEASE_INCLUDE_ISSUES",
                                       description: "Should the generator include issues?",
                                       optional: true,
                                       type: Boolean,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :split_key,
                                       env_name: "GITLAB_RELEASE_SPLIT_FINTERING_KEY",
                                       description: "A split key for separate filtering labels",
                                       optional: true,
                                       type: String,
                                       default_value: ","),
          FastlaneCore::ConfigItem.new(key: :filtering_labels,
                                       env_name: "GITLAB_RELEASE_FILTERING_LABELS",
                                       description: "A general list of labels to filter items. You must separate labels with split key (default: ,)",
                                       optional: true,
                                       type: String,
                                       default_value: ""),
          FastlaneCore::ConfigItem.new(key: :filtering_mrs_labels,
                                       env_name: "GITLAB_RELEASE_FILTERING_MRS_LABELS",
                                       description: "A specific list of labels to filter MRs. You must separate labels with split key (default: ,)",
                                       optional: true,
                                       type: String,
                                       default_value: ""),
          FastlaneCore::ConfigItem.new(key: :filtering_issues_labels,
                                       env_name: "GITLAB_RELEASE_FILTERING_ISSUES_LABELS",
                                       description: "A specific list of labels to filter issues. You must separate labels with split key (default: ,)",
                                       optional: true,
                                       type: String,
                                       default_value: "")
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
