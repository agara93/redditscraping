require 'open-uri'
require 'nokogiri'

count=0

puts " "
puts "=================="
puts "Reddit GameDeals"
puts "=================="
puts " "

print "What deals you want to see [recent/popular]? "
deals = gets.chomp

case deals
    when "recent"
    docnew = Nokogiri::HTML(open("https://www.reddit.com/r/gamedeals/new/.compact"))
    docnew.remove_namespaces!
    newdeals = docnew.xpath("//div[@class='content']/div[@id='siteTable']/div")
    
    puts " "
    puts "5 recent deals"
    puts "=============="
    puts " "

    newdeals[0..4].each do |nd|
        count+=1
        puts nd.at_css('p/a').text
        slink = nd.at_css("p[@class='title']/a/@href") # link from store
        rlink = nd.at_css('@href') # reddit link
        if slink.content == rlink.content
            puts "Store link: N/A (Self-post)"
        else
            puts "Store link: #{slink.text}"
        end
        puts "Reddit thread link: #{rlink.text}"
        puts nd.at_css("/div[@class='commentcount']/a").text + " comments" + " | " +
        nd.at_css("/div[@class='entry unvoted']/div/span[1]/time")
        time = nd.at_css("/div[@class='entry unvoted']/div/span[1]/time")
        timeutc = nd.at_css("/div[@class='entry unvoted']/div/span[1]/time/@title")
        puts "Time posted: #{time.text} | " + "#{timeutc.text}"
        puts " "
    end

    when "popular"
    doc = Nokogiri::HTML(open("https://i.reddit.com/r/gamedeals"))
    doc.remove_namespaces!
    deals = doc.xpath("//div[@class='content']/div[@id='siteTable']/div")
    
    puts " "
    puts "Popular Deals"
    puts "============="
    puts " "

    deals[1..-1].each do |dl|
        count+=1
        puts dl.at_css('p/a').text
        slink = dl.at_css("p[@class='title']/a/@href")
        rlink = dl.at_css('@href')
        if slink.content == rlink.content
            puts "Store link: N/A (Self-post)"
        else
            puts "Store link: #{slink.text}"
        end
        puts "Reddit thread link: #{rlink.text}"
        puts dl.at_css("div[@class='commentcount']/a").text + " comments" + " | " +
        dl.at_css("/div[@class='entry unvoted']/div/span[1]/span")
        time = dl.at_css("/div[@class='entry unvoted']/div/span[1]/time")
        timeutc = dl.at_css("/div[@class='entry unvoted']/div/span[1]/time/@title")
        puts "Time posted: #{time.text} | " + "#{timeutc.text}"
        puts " "
    end
    else
        puts "Invalid choice"
end

puts "#{count} sales found"
puts " "