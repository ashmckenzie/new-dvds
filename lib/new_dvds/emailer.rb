module NewDvds
  class Emailer

    attr_reader :movies

    def self.transmit movies
      new(movies).transmit
    end

    def initialize movies
      @movies = movies
    end

    def subject
      "%{title} for %{now}" % { :title => title, :now => now }
    end

    def title
      "Today's DVD releases"
    end

    def now
      Time.now.strftime('%A %d %B %Y')
    end

    def template
      template = ERB.new(File.read('./lib/new_dvds/templates/email.html.erb'))
      template.result(binding)
    end

    def body
      movies.collect do |movie|
        template = ERB.new(File.read('./lib/new_dvds/templates/shared/_movie.html.erb'))
        template.result(binding) 
      end.join("\n")
    end

    def transmit
      body = InlineStyle.process(template, :stylesheets_path => "./lib/new_dvds/templates/styles")

      mail = Mail.new
      mail.from = $CONFIG.email.from
      mail.to = $CONFIG.email.to
      mail.subject = subject

      mail.html_part do
        content_type  'text/html; charset=UTF-8'
        body body
      end

      debug_log(mail.to_s)

      unless $DRY_ON
        mail.delivery_method :sendmail
        mail.deliver!
      else
        require 'tempfile'
        filename = Tempfile.new(['new-dvds', '.html'])
        File.open(filename, 'w') { |f| f.write(body) }
        `open #{filename.path}`
        sleep(2)
      end
    end
  end
end