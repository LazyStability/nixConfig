{lib, ...}: {
  # TODO: Make a function that generates this from a path
  home.activation = {
    GenerateHomeLinks = lib.hm.dag.entryAfter ["writeBoundary"] ''
                                    # Check if the target file exists
                                    if [ ! -e "${builtins.toPath /data/Downloads}" ]; then
                                        echo "Error: Target file '${builtins.toPath /data/Downloads}' does not exist." >&2
                                        exit 1
                                    fi

                                    # Check if the link name already exists
                                    if [ -e "$HOME/Downloads" ]; then
                                        # If it's a symlink, remove it
                                        if [ -L "$HOME/Downloads" ]; then
                                            rm "$HOME/Downloads"
                                        # If it's a directory, do not overwrite
                                        elif [ -d "$HOME/Downloads" ]; then
                                            echo "Error: '$HOME/Downloads' is a directory. Not overwriting." >&2
                                            exit 1
                                        else
                                            # If it's a regular file, you can choose to remove or rename
                                            rm "$HOME/Downloads"
                                        fi
                                    fi

                                    # Create the symbolic link
                                    ln -s "${builtins.toPath /data/Downloads}" "$HOME/Downloads"
                                    echo "Soft link '$HOME/Downloads' created to '${builtins.toPath /data/Downloads}'."




                              # Check if the target file exists
                              if [ ! -e "${builtins.toPath /data/Dokumente}" ]; then
                                  echo "Error: Target file '${builtins.toPath /data/Dokumente}' does not exist." >&2
                                  exit 1
                              fi

                              # Check if the link name already exists
                              if [ -e "$HOME/Dokumente" ]; then
                                  # If it's a symlink, remove it
                                  if [ -L "$HOME/Dokumente" ]; then
                                      rm "$HOME/Dokumente"
                                  # If it's a directory, do not overwrite
                                  elif [ -d "$HOME/Dokumente" ]; then
                                      echo "Error: '$HOME/Dokumente' is a directory. Not overwriting." >&2
                                      exit 1
                                  else
                                      # If it's a regular file, you can choose to remove or rename
                                      rm "$HOME/Dokumente"
                                  fi
                              fi

                              # Create the symbolic link
                              ln -s "${builtins.toPath /data/Dokumente}" "$HOME/Dokumente"
                              echo "Soft link '$HOME/Dokumente' created to '${builtins.toPath /data/Dokumente}'."








                        # Check if the target file exists
                        if [ ! -e "${builtins.toPath /data/Videos}" ]; then
                            echo "Error: Target file '${builtins.toPath /data/Videos}' does not exist." >&2
                            exit 1
                        fi

                        # Check if the link name already exists
                        if [ -e "$HOME/Videos" ]; then
                            # If it's a symlink, remove it
                            if [ -L "$HOME/Videos" ]; then
                                rm "$HOME/Videos"
                            # If it's a directory, do not overwrite
                            elif [ -d "$HOME/Videos" ]; then
                                echo "Error: '$HOME/Videos' is a directory. Not overwriting." >&2
                                exit 1
                            else
                                # If it's a regular file, you can choose to remove or rename
                                rm "$HOME/Videos"
                            fi
                        fi

                        # Create the symbolic link
                        ln -s "${builtins.toPath /data/Videos}" "$HOME/Videos"
                        echo "Soft link '$HOME/Videos' created to '${builtins.toPath /data/Videos}'."







                  # Check if the target file exists
                  if [ ! -e "${builtins.toPath /data/Musik}" ]; then
                      echo "Error: Target file '${builtins.toPath /data/Musik}' does not exist." >&2
                      exit 1
                  fi

                  # Check if the link name already exists
                  if [ -e "$HOME/Musik" ]; then
                      # If it's a symlink, remove it
                      if [ -L "$HOME/Musik" ]; then
                          rm "$HOME/Musik"
                      # If it's a directory, do not overwrite
                      elif [ -d "$HOME/Musik" ]; then
                          echo "Error: '$HOME/Musik' is a directory. Not overwriting." >&2
                          exit 1
                      else
                          # If it's a regular file, you can choose to remove or rename
                          rm "$HOME/Musik"
                      fi
                  fi

                  # Create the symbolic link
                  ln -s "${builtins.toPath /data/Musik}" "$HOME/Musik"
                  echo "Soft link '$HOME/Musik' created to '${builtins.toPath /data/Musik}'."





            # Check if the target file exists
            if [ ! -e "${builtins.toPath /data/Bilder}" ]; then
                echo "Error: Target file '${builtins.toPath /data/Bilder} does not exist." >&2
                exit 1
            fi

            # Check if the link name already exists
            if [ -e "$HOME/Bilder" ]; then
                # If it's a symlink, remove it
                if [ -L "$HOME/Bilder" ]; then
                    rm "$HOME/Bilder"
                # If it's a directory, do not overwrite
                elif [ -d "$HOME/Bilder" ]; then
                    echo "Error: '$HOME/Bilder' is a directory. Not overwriting." >&2
                    exit 1
                else
                    # If it's a regular file, you can choose to remove or rename
                    rm "$HOME/Bilder"
                fi
            fi

            # Create the symbolic link
            ln -s "${builtins.toPath /data/Bilder}" "$HOME/Bilder"
            echo "Soft link '$HOME/Bilder' created to '${builtins.toPath /data/Bilder}'."


















      # Check if the target file exists
      if [ ! -e "${builtins.toPath /data/Software}" ]; then
          echo "Error: Target file '${builtins.toPath /data/Software}' does not exist." >&2
          exit 1
      fi

      # Check if the link name already exists
      if [ -e "$HOME/Software" ]; then
          # If it's a symlink, remove it
          if [ -L "$HOME/Software" ]; then
              rm "$HOME/Software"
          # If it's a directory, do not overwrite
          elif [ -d "$HOME/Software" ]; then
              echo "Error: '$HOME/Software' is a directory. Not overwriting." >&2
              exit 1
          else
              # If it's a regular file, you can choose to remove or rename
              rm "$HOME/Software"
          fi
      fi

      # Create the symbolic link
      ln -s "${builtins.toPath /data/Software}" "$HOME/Software"
      echo "Soft link '$HOME/Software' created to '${builtins.toPath /data/Software}'."

    '';
  };
}
