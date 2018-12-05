module Jekyll
  class TagPage < Page
    def initialize(site, base, tag)
      @site = site
      @base = base
      @tag = tag
      @name = "#{tag}.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'home.html')
      self.data['tag'] = @tag
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      site.tags.each_key do |tag|
        site.pages << TagPage.new(site, site.source, tag)
      end
    end
  end
end
