#   How to test using Rspec and Selenium WebDriver with INTER-Mediator-Server VM
#   - Install Ruby on the host of VM (You don't need installing Ruby on macOS usually)
#   - Install gem of rspec and selenium-webdriver on the host of VM ("gem install rspec selenium-webdriver")
#   - Install Firefox and geckodriver (Chrome and chromedriver) on the host of VM
#   - Change directory to the root directory of INTER-Mediator on the host of VM
#   - Run "FQDN=192.168.56.101 rspec --default-path=dist-docs/docker/spec -f doc -c dist-docs/docker/spec/samples/samples_spec.rb" on the host of VM

require "selenium-webdriver"

describe "INTER-Mediator-Server VM" do
  before do
    @protocol = 'http'
    @port = 80
    if ENV['PROTOCOL'] == 'https'
      @protocol = 'https'
      @port = 443
    end
    if ENV['PORT'] != nil
      @port = ENV['PORT']
    end
    @port = @port.to_s
    @fqdn = '127.0.0.1'
    if ENV['FQDN'] != nil
      @fqdn = ENV['FQDN']
    end
    @browser = 'firefox'
    if ENV['BROWSER'] != nil
      @browser = ENV['BROWSER'].downcase
    end
    if @browser == 'firefox'
      @driver = Selenium::WebDriver.for :firefox
    elsif @browser == 'chrome'
      @driver = Selenium::WebDriver.for :chrome
    end
    @driver.navigate.to "http://" + @fqdn + "/"
    @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
  end

  it "The title of the first page should be 'INTER-Mediator 5.7-dev - VM for Trial'." do
    expect(@driver.title).to eq("INTER-Mediator 5.7-dev - VM for Trial")
  end

  it "The path of 'Sample Program' should be '/INTER-Mediator/Samples/'." do
    element = @driver.find_element(:xpath, "//a[contains(@href, 'Samples')]")
    expect(element.attribute("href")).to eq("http://" + @fqdn + "/INTER-Mediator/Samples/")
    @driver.navigate.to element.attribute("href")
    expect(@driver.title).to eq("INTER-Mediator - Samples")
  end

  it "Practice 'search(no JavaScript)' for MySQL/MariaDB should be working" do
    @driver.navigate.to "http://" + @fqdn + "/INTER-Mediator/Samples/"
    @wait.until {
      element = @driver.find_element(:xpath, "//a[contains(@href, 'Practices/search_page1.html')]")
      element.click
      #@driver.navigate.to "http://" + @fqdn + "/INTER-Mediator/Samples/Practices/search_page1.html"
      sleep 2
      elements = @driver.find_elements(:xpath, "//div[@data-im='postalcode@f3']")
      expect(elements[0].text).to eq("1000000")
      expect(elements[1].text).to eq("1020072")
      expect(elements[19].text).to eq("1006812")

      element = @driver.find_element(:id, "_im_progress")
      expect(element.attribute("style")).to eq("opacity: 0; display: flex; z-index: -9999; transition-duration: 0.3s;")
    }
  end

  it "Practice 'search(using JavaScript)' for MySQL/MariaDB should be working" do
    @driver.navigate.to "http://" + @fqdn + "/INTER-Mediator/Samples/"
    @wait.until {
      element = @driver.find_element(:xpath, "//a[contains(@href, 'Practices/search_page2.html')]")
      element.click
      #@driver.navigate.to "http://" + @fqdn + "/INTER-Mediator/Samples/Practices/search_page2.html"
      sleep 2
      elements = @driver.find_elements(:xpath, "//div[@data-im='postalcode@f3']")
      expect(elements[0].text).to eq("1000000")
      expect(elements[1].text).to eq("1020072")
      expect(elements[19].text).to eq("1006812")

      element = @driver.find_element(:id, "_im_progress")
      expect(element.attribute("style")).to eq("opacity: 0; display: flex; z-index: -9999; transition-duration: 0.3s;")
    }
  end

  after do
    @driver.quit
  end
end
