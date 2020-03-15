# Taken from: https://github.com/dideler/dotfiles/blob/master/functions/extract.fish

function extract --description "Expand or extract bundled & compressed files" --argument archive
  if test -n "$archive" # not empty
    set archive_ $archive
  else
    echo "Usage: " (status --current-filename) "<archive-to-uncompress>"
    return 1
  end

  set --local ext (echo $archive_ | awk -F. '{print $NF}')
  switch $ext
    case tar  # non-compressed, just bundled
      tar -xvf $archive_
    case gz
      if test (echo $archive_ | awk -F. '{print $(NF-1)}') = tar  # tar bundle compressed with gzip
        tar -zxvf $archive_
      else  # single gzip
        gunzip $archive_
      end
    case tgz  # same as tar.gz
      tar -zxvf $archive_
    case bz2  # tar compressed with bzip2
      tar -jxvf $archive_
    case rar
      unrar x $archive_
    case zip
      unzip $archive_
    case xz
      if test (echo $archive_ | awk -F. '{print $(NF-1)}') = tar  # tar bundle compressed with xz
        tar -Jxf $archive_
      else  # single xz
        unxz $archive_
      end
    case '*'
      echo "Unknown extension [$ext], bailing out"
  end
end
