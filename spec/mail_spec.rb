require_relative '../lib/scrapper.rb'

$scrapper = Scrapper.new
describe "test method get_townhall_urls" do
    it "should include ABLEIGES & BOUFFEMONT & VIGNY" do
        array = []
        $scrapper.get_townhall_urls().each do |name, mail|
            array << name
        end
        expect(array.flatten).to include('ABLEIGES')
        expect(array.flatten).to include('BOUFFEMONT')
        expect(array.flatten).to include('VIGNY')
    end

    it "should find the right mail" do
        expect($scrapper.get_townhall_email("95/arnouville-les-gonesse.html")).to eq("webmaster@villedarnouville.com")
        expect($scrapper.get_townhall_email("95/bouqueval.html")).to eq("mairiebouqueval@wanadoo.fr")
        expect($scrapper.get_townhall_email("95/le-bellay-en-vexin.html")).to eq("mairie.bellay@wanadoo.fr")
      end

    it "should not include nil" do
        array_keys = []
        array_values = []
        $scrapper.get_townhall_urls().each do |name, mail|
            array_keys << name
            array_values << mail
        end
        expect(array_keys).not_to include('nil')
        expect(array_values).not_to include('nil')
    end

    it "should have at least 185 mails" do
        expect($scrapper.get_townhall_urls().length).to eq(185)
    end
end