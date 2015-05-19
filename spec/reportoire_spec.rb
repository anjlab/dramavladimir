require 'spec_helper'

describe Dramavladimir::Repertoire do
  let(:repertoire) { Dramavladimir::Repertoire.new }
  let(:data) { { title: "Собачье сердце", date: "2015-05-03 18:00:00", scene: "малая " } }
  let(:spectacles) { repertoire.spectacles }

  # it { expect(repertoire.get_afisha_links.count).to eq(1) }
  # it { expect(spectacles.count).to eq(17) }
  it { expect(spectacles.first).to eq(data) }
end
