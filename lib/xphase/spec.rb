require 'open-uri'
require 'json'


class Xphase::Spec

    DEBUG       = true
    PATH_BASE   = "https://raw.githubusercontent.com/CoreKit/xphase/master/phases/"
    PATH_SPEC   = "/spec.json"
    PATH_SCRIPT = "/script.sh"

    attr_reader :id

    attr_reader :name
    attr_reader :description
    attr_reader :author

    attr_reader :dependency
    attr_reader :params

    attr_reader :template

    def specLocation
        if ENV["XPHASE_LOCAL"].nil?
            PATH_BASE + @id + PATH_SPEC
        else
            Dir.getwd + "/../phases/" + @id + PATH_SPEC
        end
    end

    def scriptLocation
        if ENV["XPHASE_LOCAL"].nil?
            PATH_BASE + @id + PATH_SCRIPT
        else
            Dir.getwd + "/../phases/" + @id + PATH_SCRIPT
        end
    end


    def self.new(val)
        @@obj = super(val)

        if @@obj.id.nil?
            return nil
        end
        return @@obj
    end


    def initialize(id)
        @id = id
        begin
            if ENV["XPHASE_LOCAL"].nil?
                contents  = open(self.specLocation).read
                @template = open(self.scriptLocation).read
            else
                contents  = File.open(self.specLocation, "rb").read
                @template = File.open(self.scriptLocation, "rb").read
            end
        rescue
            @id = nil
            return
        end

        json         = JSON.parse(contents)

        @name        = json["name"]
        @description = json["description"]
        @author      = json["author"]

        @dependency  = json["dependency"]
        @params      = json["params"]

    end

    def script(params)

        script = @template
        if !params.nil?
            params.each do |key, value|
                if key.eql? "flags"
                    script = script + ' ' + value
                    next
                end
                script = script.gsub('{{'+key+'}}', value)
            end
        end
        script
    end

end
