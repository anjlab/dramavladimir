require 'spec_helper'

describe Dramavladimir::Repertoire do
  let(:repertoire) { Dramavladimir::Repertoire.new }
  let(:data_1) { { title: "Собачье сердце", schedules: "2015-05-03 18:00:00", scene: "малая " } }
  let(:data_2) { { title: "Собачье сердце", schedules: "2015-05-03 18:00:00", scene: "малая " } }

  before {
    @spectacles = repertoire.spectacles
  }

  # it { expect(repertoire.get_afisha_links.count).to eq(1) }
  # it { expect(spectacles.count).to eq(17) }
  it { expect(@spectacles[0]).to eq(data_1) }
  it { expect(@spectacles[1]).to eq(data_2) }
end
