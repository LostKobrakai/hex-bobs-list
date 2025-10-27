defmodule BobVersionsTest do
  use ExUnit.Case, async: true

  describe "text_to_data/2 - elixir" do
    test "success V1" do
      string = """
      v0.12.4 543dfdeac80cfaf3483927c189cf9974f1e361eb 2016-06-02T12:43:53Z
      v0.12.5 b07fbcf8b73e9353cc336107050a8aac5fdabd11 2016-06-02T12:42:56Z
      v0.13.0 ada53524caa6ea27ffaa1a373f5c86bd6cadb0d5 2016-06-02T12:42:00Z
      """

      assert %{
               "v0.12" => [
                 %{
                   git: %{
                     sha: "543dfdeac80cfaf3483927c189cf9974f1e361eb",
                     url:
                       "https://github.com/elixir-lang/elixir/commit/543dfdeac80cfaf3483927c189cf9974f1e361eb"
                   },
                   minor_version: "v0.12",
                   version: "v0.12.4",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum: "",
                       download: "https://repo.hex.pm/builds/elixir/v0.12.4.zip",
                       git: %{
                         sha: "543dfdeac80cfaf3483927c189cf9974f1e361eb",
                         url:
                           "https://github.com/elixir-lang/elixir/commit/543dfdeac80cfaf3483927c189cf9974f1e361eb"
                       },
                       timestamp: ~U[2016-06-02 12:43:53Z],
                       version: %{elixir: "v0.12.4", otp: "Default"}
                     }
                   ]
                 },
                 %{
                   git: %{
                     sha: "b07fbcf8b73e9353cc336107050a8aac5fdabd11",
                     url:
                       "https://github.com/elixir-lang/elixir/commit/b07fbcf8b73e9353cc336107050a8aac5fdabd11"
                   },
                   minor_version: "v0.12",
                   version: "v0.12.5",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum: "",
                       download: "https://repo.hex.pm/builds/elixir/v0.12.5.zip",
                       git: %{
                         sha: "b07fbcf8b73e9353cc336107050a8aac5fdabd11",
                         url:
                           "https://github.com/elixir-lang/elixir/commit/b07fbcf8b73e9353cc336107050a8aac5fdabd11"
                       },
                       timestamp: ~U[2016-06-02 12:42:56Z],
                       version: %{elixir: "v0.12.5", otp: "Default"}
                     }
                   ]
                 }
               ],
               "v0.13" => [
                 %{
                   git: %{
                     sha: "ada53524caa6ea27ffaa1a373f5c86bd6cadb0d5",
                     url:
                       "https://github.com/elixir-lang/elixir/commit/ada53524caa6ea27ffaa1a373f5c86bd6cadb0d5"
                   },
                   minor_version: "v0.13",
                   version: "v0.13.0",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum: "",
                       download: "https://repo.hex.pm/builds/elixir/v0.13.0.zip",
                       git: %{
                         sha: "ada53524caa6ea27ffaa1a373f5c86bd6cadb0d5",
                         url:
                           "https://github.com/elixir-lang/elixir/commit/ada53524caa6ea27ffaa1a373f5c86bd6cadb0d5"
                       },
                       timestamp: ~U[2016-06-02 12:42:00Z],
                       version: %{elixir: "v0.13.0", otp: "Default"}
                     }
                   ]
                 }
               ]
             } =
               BobVersions.text_to_data(:elixir, string,
                 availability: &undetermined_availability/1
               )
    end

    test "success V2" do
      string = """
      v0.12.4 543dfdeac80cfaf3483927c189cf9974f1e361eb 2016-06-02T12:43:53Z 950f5a6784cb556199797c6f7f0205db5c17dbbf1a7ce0aabdf575429c16c89c
      v0.12.5 b07fbcf8b73e9353cc336107050a8aac5fdabd11 2016-06-02T12:42:56Z d11c2d82a603a1362797a181dd8c8a2a5d6d9c6e5e54cfb03e8cb96443b91828
      """

      assert %{
               "v0.12" => [
                 %{
                   git: %{
                     sha: "543dfdeac80cfaf3483927c189cf9974f1e361eb",
                     url:
                       "https://github.com/elixir-lang/elixir/commit/543dfdeac80cfaf3483927c189cf9974f1e361eb"
                   },
                   minor_version: "v0.12",
                   version: "v0.12.4",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum:
                         "950f5a6784cb556199797c6f7f0205db5c17dbbf1a7ce0aabdf575429c16c89c",
                       download: "https://repo.hex.pm/builds/elixir/v0.12.4.zip",
                       git: %{
                         sha: "543dfdeac80cfaf3483927c189cf9974f1e361eb",
                         url:
                           "https://github.com/elixir-lang/elixir/commit/543dfdeac80cfaf3483927c189cf9974f1e361eb"
                       },
                       timestamp: ~U[2016-06-02 12:43:53Z],
                       version: %{elixir: "v0.12.4", otp: "Default"}
                     }
                   ]
                 },
                 %{
                   git: %{
                     sha: "b07fbcf8b73e9353cc336107050a8aac5fdabd11",
                     url:
                       "https://github.com/elixir-lang/elixir/commit/b07fbcf8b73e9353cc336107050a8aac5fdabd11"
                   },
                   minor_version: "v0.12",
                   version: "v0.12.5",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum:
                         "d11c2d82a603a1362797a181dd8c8a2a5d6d9c6e5e54cfb03e8cb96443b91828",
                       download: "https://repo.hex.pm/builds/elixir/v0.12.5.zip",
                       git: %{
                         sha: "b07fbcf8b73e9353cc336107050a8aac5fdabd11",
                         url:
                           "https://github.com/elixir-lang/elixir/commit/b07fbcf8b73e9353cc336107050a8aac5fdabd11"
                       },
                       timestamp: ~U[2016-06-02 12:42:56Z],
                       version: %{elixir: "v0.12.5", otp: "Default"}
                     }
                   ]
                 }
               ]
             } =
               BobVersions.text_to_data(:elixir, string,
                 availability: &undetermined_availability/1
               )
    end

    test "does ignore additional data" do
      string = """
      v0.12.4 543dfdeac80cfaf3483927c189cf9974f1e361eb 2016-06-02T12:43:53Z 950f5a6784cb556199797c6f7f0205db5c17dbbf1a7ce0aabdf575429c16c89c 123
      v0.12.5 b07fbcf8b73e9353cc336107050a8aac5fdabd11 2016-06-02T12:42:56Z d11c2d82a603a1362797a181dd8c8a2a5d6d9c6e5e54cfb03e8cb96443b91828 123 456
      """

      assert %{"v0.12" => [_, _]} =
               BobVersions.text_to_data(:elixir, string,
                 availability: &undetermined_availability/1
               )
    end
  end

  describe "text_to_data/2 - erlang" do
    test "success V1" do
      string = """
      OTP-19.2 3473ecd83a7bbe7e0bebb865f25dddb93e3bf10f 2020-03-18T17:30:34Z
      OTP-19.3.6.9 3d0c4930775cf2ab304d5e4701b41ffc2936ce53 2020-03-18T17:42:18Z
      OTP-20.0 040bdce67f88d833bfb59adae130a4ffb4c180f0 2020-03-18T17:42:46Z
      """

      assert %{
               "OTP-19" => [
                 %{
                   git: %{
                     sha: "3473ecd83a7bbe7e0bebb865f25dddb93e3bf10f",
                     url:
                       "https://github.com/erlang/otp/commit/3473ecd83a7bbe7e0bebb865f25dddb93e3bf10f"
                   },
                   minor_version: "OTP-19",
                   version: "OTP-19.2",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum: "",
                       download: "https://repo.hex.pm/builds/otp/ubuntu-14.04/OTP-19.2.tar.gz",
                       git: %{
                         sha: "3473ecd83a7bbe7e0bebb865f25dddb93e3bf10f",
                         url:
                           "https://github.com/erlang/otp/commit/3473ecd83a7bbe7e0bebb865f25dddb93e3bf10f"
                       },
                       timestamp: ~U[2020-03-18T17:30:34Z],
                       version: %{erlang: "OTP-19.2"}
                     }
                   ]
                 },
                 %{
                   git: %{
                     sha: "3d0c4930775cf2ab304d5e4701b41ffc2936ce53",
                     url:
                       "https://github.com/erlang/otp/commit/3d0c4930775cf2ab304d5e4701b41ffc2936ce53"
                   },
                   minor_version: "OTP-19",
                   version: "OTP-19.3",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum: "",
                       download:
                         "https://repo.hex.pm/builds/otp/ubuntu-14.04/OTP-19.3.6.9.tar.gz",
                       git: %{
                         sha: "3d0c4930775cf2ab304d5e4701b41ffc2936ce53",
                         url:
                           "https://github.com/erlang/otp/commit/3d0c4930775cf2ab304d5e4701b41ffc2936ce53"
                       },
                       timestamp: ~U[2020-03-18T17:42:18Z],
                       version: %{erlang: "OTP-19.3.6.9"}
                     }
                   ]
                 }
               ],
               "OTP-20" => [
                 %{
                   git: %{
                     sha: "040bdce67f88d833bfb59adae130a4ffb4c180f0",
                     url:
                       "https://github.com/erlang/otp/commit/040bdce67f88d833bfb59adae130a4ffb4c180f0"
                   },
                   minor_version: "OTP-20",
                   version: "OTP-20.0",
                   versions: [
                     %{
                       availability: :undetermined,
                       checksum: "",
                       download: "https://repo.hex.pm/builds/otp/ubuntu-14.04/OTP-20.0.tar.gz",
                       git: %{
                         sha: "040bdce67f88d833bfb59adae130a4ffb4c180f0",
                         url:
                           "https://github.com/erlang/otp/commit/040bdce67f88d833bfb59adae130a4ffb4c180f0"
                       },
                       timestamp: ~U[2020-03-18T17:42:46Z],
                       version: %{erlang: "OTP-20.0"}
                     }
                   ]
                 }
               ]
             } =
               BobVersions.text_to_data({:erlang, :ubuntu_14}, string,
                 availability: &undetermined_availability/1
               )
    end
  end

  defp undetermined_availability(list) do
    Enum.map(list, fn item -> Map.put(item, :availability, :undetermined) end)
  end
end
