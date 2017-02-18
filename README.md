#xphase
Build phase manager for Xcode

---

> It's like a package manager for your Xcode build phases.


###Installation

```bash
sudo gem install xphase
```

### Usage

Create your phase file (xphase.json) next to your Xcode project like this:

You can use the **`xphase init`** command to create a template file.

```json
{
  "*": {
    "phases": [
      {
        "spec": "swiftlint"
      },
      {
        "spec": "build-version",
        "params": {
          "counter": "git rev-list --all --count"
        }
      },
      {
        "spec": "iconer",
        "params": {
          "source": "${SRCROOT}/Applications/${TARGET_NAME}/iOS/Application/Assets/AppIcon.png",
          "target": "${SRCROOT}/Applications/${TARGET_NAME}/iOS/Application/Assets",
          "platform": "ios"
        }
      },
      {
        "spec": "r-swift",
        "params": {
          "target": "${SRCROOT}/Applications/${TARGET_NAME}/iOS/Application/Assets",
          "flags": "--rswiftignore \"${SRCROOT}/Applications/\""
        }
      }
    ]
  }
}
```

Run **`xphase install`** to install the build phases.


To remove all shell scripts from an Xcode project run **`xphase uninstall`**.

*WARNING:* this will remove every shell script build phase from the Xcode project!


### Anatomy of the xphase.json files

```json
{
    "<target_name>": {
        "phases": [
            {
                "name": "Icon generator",
                "spec": "iconer",
                "params": {
                    "example_param": "example value",
                    "flags": "--verbose"
                }
            }
        ]
    }
}

```

- target_name: The Xcode target name to install phases. Use the `*` character as name for shared phases.
- phases: The array of Xcode build phase specs that you would like to install.
- spec: The unique identifier of the xphase spec. Check the [phases](https://github.com/CoreKit/xphase/tree/master/phases) directory for available specs.
- name: You can define your own name for each build phase. (By default spec id will be used as name)
- params: Various parameters for the build scripts. Check the spec definition for available options
- flags: You can use the special `flags` param to append extra info to the end of the phase scripts.


### Notes

I'm not a ruby developer, I just wanted to make this happen because I felt the need for a build phase package manager for Xcode. I did this little project in ~ 5 days without any ruby knowledge, feel free to make my code better, all contributors are welcome.



### License
[WTFPL](LICENSE)


