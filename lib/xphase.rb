require 'xcodeproj'

require 'open-uri'
require 'json'

# cmd = "which iconer"
# value = `#{cmd}`
# puts value.empty?

# project.targets.each do |target|
#     target.build_configurations.each do |config|
#         config.build_settings['XPHASE_PLATFORM'] = "iOS"
#     end
# end

# lib_path = "your_lib_path";
# Add the lib file as a reference
# libRef = project['Frameworks'].new_file(lib_path);
# Get the build phase
# framework_buildphase = project.objects.select{|x| x.class == Xcodeproj::Project::Object::PBXFrameworksBuildPhase}[0];
# Add it to the build phase
# framework_buildphase.add_file_reference(libRef);

class Xphase

    XPHASE_FILE = "xphase.json"


    def setup
        puts "▸ creating phase file for your project..."

    end

    def init
        puts "Xphase started:"

        puts " ▸ Creating xphase.json file..."

        current_work_dir = Dir.pwd
        current_file     = "#{current_work_dir}/#{XPHASE_FILE}"

        project = self.loadProject

        phasefile = {
            :* => {:phases => []}
        }

        project.targets.each do |target|
            phasefile[target.name] = {:phases => []}
        end

        File.open(current_file, 'w').write(phasefile.to_json)
        puts "Xphase finished running."
    end

    def uninstall
        puts "Xphase started:"
        project = self.loadProject
        project.targets.each do |target|
            puts " ▸ Removing phases for target: '" + target.name + "'"
            target.shell_script_build_phases.each do |value|
                target.build_phases.delete(value)
            end
        end
        project.save

        puts "Xphase finished running."
    end


    def install

        project = self.loadProject
        json    = self.loadPhases

        puts "Xphase started:"

        project.targets.each do |target|
            puts " ▸ Setting up phases for target: '" + target.name + "'"

            if !json["*"].nil? && !json["*"]["phases"].nil?
                installPhasesForTarget(json["*"]["phases"], target)
            end

            if !json[target.name].nil? && !json[target.name]["phases"].nil?
                installPhasesForTarget(json[target.name]["phases"], target)
            end
        end
        project.save
        puts "Xphase finished running."

    end

    def loadPhases
        current_work_dir = Dir.pwd
        current_file     = "#{current_work_dir}/#{XPHASE_FILE}"
        contents         = File.open(current_file, "rb").read
        json             = JSON.parse(contents)
        json
    end

    def loadProject
        current_work_dir     = Dir.pwd
        current_source_files = "#{current_work_dir}/*.xcodeproj"

        if Dir[current_source_files].count == 0
            error " ▸ No Xcode file found in the project directory."
            exit -1
        end

        project_path = Dir[current_source_files].first

        begin
            project = Xcodeproj::Project.open project_path
        rescue
            error " ▸ Can't open Xcode project file."
            exit -1
        end

        project
    end

    def installPhasesForTarget(phases, target)

        phases.each do |phase|

            spec = Spec.new(phase["spec"])

            if spec.nil?
                puts "  • Could not find phase with identifier: '" + phase["spec"] + "'"
                next
            end

            script_name = spec.name
            if !phase["name"].nil?
                script_name = phase["name"]
            end
            script_value = spec.script(phase["params"])

            puts "  • Setting up '" + spec.id + "' with the name: '" + script_name + "'"

            script = nil
            target.shell_script_build_phases.each do |value|
                if value.name == script_name
                    script = value
                    break
                end
            end

            if !script
                script = target.new_shell_script_build_phase script_name
            end

            script.shell_script = script_value
        end
    end

end


require 'xphase/spec'
