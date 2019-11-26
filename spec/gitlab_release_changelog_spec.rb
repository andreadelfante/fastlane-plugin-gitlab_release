describe Fastlane::Actions::GitlabReleaseChangelog do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The gitlab_release plugin is working!")

      Fastlane::Actions::GitlabReleaseChangelog.run(nil)
    end
  end
end
