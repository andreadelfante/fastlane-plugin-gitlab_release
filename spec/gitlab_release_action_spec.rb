describe Fastlane::Actions::GitlabReleaseAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The gitlab_release plugin is working!")

      Fastlane::Actions::GitlabReleaseAction.run(nil)
    end
  end
end
