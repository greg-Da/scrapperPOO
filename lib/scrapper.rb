require 'nokogiri'
require 'open-uri'

class Scrapper

    def perform
        hash = get_townhall_urls()
        save_as_JSON(hash)
        save_as_spreadsheet(hash)
        save_as_CSV(hash)
    end

    def get_townhall_email(townhall_url)
        page = Nokogiri::HTML(URI.open("https://www.annuaire-des-mairies.com/#{townhall_url}"))

        mail = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
    end


    def get_townhall_urls

        hash = {}

        page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))

        page.css('a.lientxt').each do |link|
            hash[link.content] = get_townhall_email(link['href'][1..-1])
        end
        return hash
    end

    def save_as_JSON(hash)
        File.open("db/emails.JSON","w") do |line|
			#ecrit dans le JSON
		  line.write(hash.to_json)
		end
    end

    def save_as_spreadsheet(hash)
        session = GoogleDrive::Session.from_config(".env")
        ws = session.spreadsheet_by_title("scrapperMail").worksheets[0]
        hash.each_with_index do |elem, index|
            ws[1 + index, 1] = elem[0]
            ws[1 + index, 2] = elem[1]
        end

        ws.save
    end

    def save_as_CSV(hash)
        CSV.open("db/emails.csv", "w") do |csv|
            csv << ["city","email"]

            hash.each do |name, mail|
                csv << [name, mail]
            end
        end
    end
end