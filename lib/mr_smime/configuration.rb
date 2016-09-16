module MrSmime
  class Configuration
    attr_accessor :certificate_path, :enabled

    def initialize
      @enabled = true
    end
  end
end
