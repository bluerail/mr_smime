require 'spec_helper'
require 'shared_examples_for_mail'

describe MrSmime do
  let(:example_certificate_path) { File.join(File.dirname(__FILE__), 'fixtures', 'certificates') }

  before do
    MrSmime.configure do |config|
      config.certificate_path = example_certificate_path
    end
  end

  it 'has a version number' do
    expect(MrSmime::VERSION).not_to be nil
  end

  it 'registers an interceptor' do
    expect(Mail.class_variable_get(:@@delivery_interceptors)).to include MrSmime::Interceptor
  end

  describe '#configure' do
    it 'has no default certificate path' do
      expect(MrSmime.configuration.certificate_path).not_to be_nil
    end

    context 'with configuration' do
      before do
        MrSmime.configure do |config|
          config.certificate_path = nil
        end
      end

      it 'can set certificate_path' do
        expect(MrSmime.configuration.certificate_path).to be_nil
      end
    end
  end

  context 'with sender with certificate' do
    let!(:sender) { 'john@example.com' }

    context 'with recipient with certificate' do
      let!(:recipient) { 'jane@example.com' }

      it_should_behave_like 'a encryptable mail'
    end

    context 'with recipient without certificate' do
      let!(:recipient) { 'janie@example.com' }

      it_should_behave_like 'a signable mail'
      it_should_behave_like 'a non encryptable mail'
    end

    context 'with mixed recipients' do
      let!(:recipient) { %w(jane@example.com janie@example.com) }

      it_should_behave_like 'a signable mail'
      it_should_behave_like 'a non encryptable mail'
    end
  end

  context 'with sender without certificate' do
    let!(:sender) { 'johnnie@example.com' }

    context 'with recipient with certificate' do
      let!(:recipient) { 'jane@example.com' }

      it_should_behave_like 'a non signable mail'
      it_should_behave_like 'a non encryptable mail'
    end

    context 'with recipient without certificate' do
      let!(:recipient) { 'janie@example.com' }

      it_should_behave_like 'a non signable mail'
      it_should_behave_like 'a non encryptable mail'
    end

    context 'with mixed recipients' do
      let!(:recipient) { %w(jane@example.com janie@example.com) }

      it_should_behave_like 'a non signable mail'
      it_should_behave_like 'a non encryptable mail'
    end
  end

  context 'when disabled' do
    before do
      MrSmime.configure do |config|
        config.enabled = false
      end
    end

    let!(:sender) { 'john@example.com' }

    context 'with recipient with certificate' do
      let!(:recipient) { 'jane@example.com' }

      it_should_behave_like 'a non encryptable mail'
    end

    context 'with recipient without certificate' do
      let!(:recipient) { 'janie@example.com' }

      it_should_behave_like 'a non signable mail'
      it_should_behave_like 'a non encryptable mail'
    end

    context 'with mixed recipients' do
      let!(:recipient) { %w(jane@example.com janie@example.com) }

      it_should_behave_like 'a non signable mail'
      it_should_behave_like 'a non encryptable mail'
    end
  end
end
