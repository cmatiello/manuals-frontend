require 'rails_helper'
require 'gds_api/content_store'

RSpec.describe ManualPresenter do
  subject { described_class.new(manual) }
  let(:content_store) { GdsApi::ContentStore.new(Plek.new.find('content-store')) }

  context 'for a normal manual' do
    let(:manual) do
      stub_fake_manual
      content_store.content_item "/guidance/my-manual-about-burritos"
    end

    it 'does not think it is an hmrc manual' do
      expect(subject.hmrc?).to eq false
    end

    it 'does not think it is a beta manual' do
      expect(subject.beta?).to eq false
    end
  end

  context 'for an HMRC manual' do
    let(:manual) do
      stub_hmrc_manual
      content_store.content_item "/hmrc-internal-manuals/inheritance-tax-manual"
    end

    it 'knows it is an hmrc manual' do
      expect(subject.hmrc?).to eq true
    end

    it 'knows it is a beta manual' do
      expect(subject.beta?).to eq true
    end
  end

  context '#updated_at' do
    let(:manual) do
      stub_fake_manual(public_updated_at: public_updated_at)
      content_store.content_item "/guidance/my-manual-about-burritos"
    end

    context 'when the public_updated_at of the content item is populated' do
      let(:public_updated_at) { "2014-06-20T10:17:29+01:00" }

      it "parses the public_updated_at to return a Date object" do
        expect(subject.updated_at).to eq Date.new(2014,06,20)
      end
    end

    context 'when the public_updated_at of the content item is missing' do
      let(:public_updated_at) { nil }

      it "returns nil" do
        expect(subject.updated_at).to be_nil
      end
    end
  end
end
