require File.join(File.dirname(__FILE__), 'helper')

class ScoreCacheDiggTest < ScoreCacheTest
  context 'Oursignal::Score::Cache::Digg' do
    setup do
      @digg = Oursignal::Score::Cache::Digg.new
    end

    context '.poll' do
      should 'run without errors' do
        assert_nothing_raised do
          Nokogiri::XML.parse(@digg.poll)
        end
      end
    end

    context '.work' do
      should 'run without errors' do
        assert_nothing_raised do
          @digg.work(@digg.poll)
        end
      end
    end
  end
end

