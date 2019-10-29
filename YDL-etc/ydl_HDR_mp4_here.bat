@echo on
Setlocal EnableDelayedExpansion
REM
REM download both webm and mp4.
REM
REM c:
REM md temp
REM cd temp

set youtube_dl_exe=C:\SOFTWARE\youtube-dl\youtube-dl.exe
set config_location=C:\SOFTWARE\youtube-dl\config.ini
set ffmpeg_location=C:\SOFTWARE\youtube-dl\ffmpeg.exe

REM "%youtube_dl_exe%" --ignore-config --help > .\youtube-dl.help.fullhelp.txt 2>&1
REM "%youtube_dl_exe%" --ignore-config --extractor-descriptions > .\youtube-dl.help.extractor-descriptions.txt 2>&1
REM https://github.com/rg3/youtube-dl/blob/master/README.md#format-selection

SET /P theURL=Enter the full youtube or other URL:

REM display available formats
"%youtube_dl_exe%" --no-call-home --ignore-config --prefer-ffmpeg --ffmpeg-location "%ffmpeg_location%" --buffer-size 64k --no-mtime --console-title --force-ipv4 --no-mark-watched --ignore-errors --list-formats %theURL% 
"%youtube_dl_exe%" --no-call-home --ignore-config --prefer-ffmpeg --ffmpeg-location "%ffmpeg_location%" --buffer-size 64k --no-mtime --console-title --force-ipv4 --no-mark-watched --ignore-errors --list-formats %theURL% > z.available.formats.log 2>&1

REM Choose HDR vp9.2 = vp9 profile 2 first - 337/336/335/334
REM --format "337/336/335/334/315/313/271/264/303/299/248/137/302/298/247/136/22/(bestvideo+bestaudio/best)"
"%youtube_dl_exe%" --no-call-home --ignore-config --prefer-ffmpeg --ffmpeg-location "%ffmpeg_location%" --buffer-size 64k --no-mtime --console-title --force-ipv4 --no-mark-watched --ignore-errors --restrict-filenames --format "(337/336/335/334/315/313/271/264/303/299/248/137/302/298/247/136/22/bestvideo)+bestaudio/best" %theURL%

REM Choose HDR mp4 first - 264/299/137/298/136/22
REM --format "264/299/137/298/136/22/(bestvideo+bestaudio/best)" or bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]
"%youtube_dl_exe%" --no-call-home --ignore-config --prefer-ffmpeg --ffmpeg-location "%ffmpeg_location%" --buffer-size 64k --no-mtime --console-title --force-ipv4 --no-mark-watched --ignore-errors --restrict-filenames --format " bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]" %theURL%

pause
exit


REM vp9.2 UHD = 337, 336, 335, 334


271
REM vp9 max = 315,313,308,303,302
REM avc1 max = 254,299,137,298,136
REM 
REM If you want to download multiple videos and they don't have the same formats available,
REM you can specify the order of preference using slashes.
REM Note that slash is left-associative,
REM i.e. formats on the left hand side are preferred, 
REM for example -f 22/17/18 will download format 22 if it's available, 
REM otherwise it will download format 17 if it's available, 
REM otherwise it will download format 18 if it's available, 
REM otherwise it will complain that no suitable formats are available for download.
REM 
REM Or a more sophisticated example combined with the precedence feature: -f 136/137/mp4/bestvideo,140/m4a/bestaudio.
REM 337/336/335/334/bestvideo


REM "%youtube_dl_exe%" --ignore-config --help > .\youtube-dl.help.fullhelp.txt 2>&1
REM "%youtube_dl_exe%" --ignore-config --extractor-descriptions > .\youtube-dl.help.extractor-descriptions.txt 2>&1


Options:
  General Options:
    -h, --help                       Print this help text and exit
    --version                        Print program version and exit
    -U, --update                     Update this program to latest version. Make
                                     sure that you have sufficient permissions
                                     (run with sudo if needed)
    -i, --ignore-errors              Continue on download errors, for example to
                                     skip unavailable videos in a playlist
    --abort-on-error                 Abort downloading of further videos (in the
                                     playlist or the command line) if an error
                                     occurs
    --dump-user-agent                Display the current browser identification
    --list-extractors                List all supported extractors
    --extractor-descriptions         Output descriptions of all supported
                                     extractors
    --force-generic-extractor        Force extraction to use the generic
                                     extractor
    --default-search PREFIX          Use this prefix for unqualified URLs. For
                                     example "gvsearch2:" downloads two videos
                                     from google videos for youtube-dl "large
                                     apple". Use the value "auto" to let
                                     youtube-dl guess ("auto_warning" to emit a
                                     warning when guessing). "error" just throws
                                     an error. The default value "fixup_error"
                                     repairs broken URLs, but emits an error if
                                     this is not possible instead of searching.
    --ignore-config                  Do not read configuration files. When given
                                     in the global configuration file /etc
                                     /youtube-dl.conf: Do not read the user
                                     configuration in ~/.config/youtube-
                                     dl/config (%APPDATA%/youtube-dl/config.txt
                                     on Windows)
    --config-location PATH           Location of the configuration file; either
                                     the path to the config or its containing
                                     directory.
    --flat-playlist                  Do not extract the videos of a playlist,
                                     only list them.
    --mark-watched                   Mark videos watched (YouTube only)
    --no-mark-watched                Do not mark videos watched (YouTube only)
    --no-color                       Do not emit color codes in output

  Network Options:
    --proxy URL                      Use the specified HTTP/HTTPS/SOCKS proxy.
                                     To enable experimental SOCKS proxy, specify
                                     a proper scheme. For example
                                     socks5://127.0.0.1:1080/. Pass in an empty
                                     string (--proxy "") for direct connection
    --socket-timeout SECONDS         Time to wait before giving up, in seconds
    --source-address IP              Client-side IP address to bind to
    -4, --force-ipv4                 Make all connections via IPv4
    -6, --force-ipv6                 Make all connections via IPv6
    --geo-verification-proxy URL     Use this proxy to verify the IP address for
                                     some geo-restricted sites. The default
                                     proxy specified by --proxy (or none, if the
                                     options is not present) is used for the
                                     actual downloading.

  Video Selection:
    --playlist-start NUMBER          Playlist video to start at (default is 1)
    --playlist-end NUMBER            Playlist video to end at (default is last)
    --playlist-items ITEM_SPEC       Playlist video items to download. Specify
                                     indices of the videos in the playlist
                                     separated by commas like: "--playlist-items
                                     1,2,5,8" if you want to download videos
                                     indexed 1, 2, 5, 8 in the playlist. You can
                                     specify range: "--playlist-items
                                     1-3,7,10-13", it will download the videos
                                     at index 1, 2, 3, 7, 10, 11, 12 and 13.
    --match-title REGEX              Download only matching titles (regex or
                                     caseless sub-string)
    --reject-title REGEX             Skip download for matching titles (regex or
                                     caseless sub-string)
    --max-downloads NUMBER           Abort after downloading NUMBER files
    --min-filesize SIZE              Do not download any videos smaller than
                                     SIZE (e.g. 50k or 44.6m)
    --max-filesize SIZE              Do not download any videos larger than SIZE
                                     (e.g. 50k or 44.6m)
    --date DATE                      Download only videos uploaded in this date
    --datebefore DATE                Download only videos uploaded on or before
                                     this date (i.e. inclusive)
    --dateafter DATE                 Download only videos uploaded on or after
                                     this date (i.e. inclusive)
    --min-views COUNT                Do not download any videos with less than
                                     COUNT views
    --max-views COUNT                Do not download any videos with more than
                                     COUNT views
    --match-filter FILTER            Generic video filter. Specify any key (see
                                     help for -o for a list of available keys)
                                     to match if the key is present, !key to
                                     check if the key is not present, key >
                                     NUMBER (like "comment_count > 12", also
                                     works with >=, <, <=, !=, =) to compare
                                     against a number, and & to require multiple
                                     matches. Values which are not known are
                                     excluded unless you put a question mark (?)
                                     after the operator. For example, to only
                                     match videos that have been liked more than
                                     100 times and disliked less than 50 times
                                     (or the dislike functionality is not
                                     available at the given service), but who
                                     also have a description, use --match-filter
                                     "like_count > 100 & dislike_count <? 50 &
                                     description" .
    --no-playlist                    Download only the video, if the URL refers
                                     to a video and a playlist.
    --yes-playlist                   Download the playlist, if the URL refers to
                                     a video and a playlist.
    --age-limit YEARS                Download only videos suitable for the given
                                     age
    --download-archive FILE          Download only videos not listed in the
                                     archive file. Record the IDs of all
                                     downloaded videos in it.
    --include-ads                    Download advertisements as well
                                     (experimental)

  Download Options:
    -r, --limit-rate RATE            Maximum download rate in bytes per second
                                     (e.g. 50K or 4.2M)
    -R, --retries RETRIES            Number of retries (default is 10), or
                                     "infinite".
    --fragment-retries RETRIES       Number of retries for a fragment (default
                                     is 10), or "infinite" (DASH and hlsnative
                                     only)
    --skip-unavailable-fragments     Skip unavailable fragments (DASH and
                                     hlsnative only)
    --abort-on-unavailable-fragment  Abort downloading when some fragment is not
                                     available
    --buffer-size SIZE               Size of download buffer (e.g. 1024 or 16K)
                                     (default is 1024)
    --no-resize-buffer               Do not automatically adjust the buffer
                                     size. By default, the buffer size is
                                     automatically resized from an initial value
                                     of SIZE.
    --playlist-reverse               Download playlist videos in reverse order
    --playlist-random                Download playlist videos in random order
    --xattr-set-filesize             Set file xattribute ytdl.filesize with
                                     expected file size (experimental)
    --hls-prefer-native              Use the native HLS downloader instead of
                                     ffmpeg
    --hls-prefer-ffmpeg              Use ffmpeg instead of the native HLS
                                     downloader
    --hls-use-mpegts                 Use the mpegts container for HLS videos,
                                     allowing to play the video while
                                     downloading (some players may not be able
                                     to play it)
    --external-downloader COMMAND    Use the specified external downloader.
                                     Currently supports
                                     aria2c,avconv,axel,curl,ffmpeg,httpie,wget
    --external-downloader-args ARGS  Give these arguments to the external
                                     downloader

  Filesystem Options:
    -a, --batch-file FILE            File containing URLs to download ('-' for
                                     stdin)
    --id                             Use only video ID in file name
    -o, --output TEMPLATE            Output filename template, see the "OUTPUT
                                     TEMPLATE" for all the info
    --autonumber-size NUMBER         Specify the number of digits in
                                     %(autonumber)s when it is present in output
                                     filename template or --auto-number option
                                     is given (default is 5)
    --autonumber-start NUMBER        Specify the start value for %(autonumber)s
                                     (default is 1)
    --restrict-filenames             Restrict filenames to only ASCII
                                     characters, and avoid "&" and spaces in
                                     filenames
    -A, --auto-number                [deprecated; use -o
                                     "%(autonumber)s-%(title)s.%(ext)s" ] Number
                                     downloaded files starting from 00000
    -t, --title                      [deprecated] Use title in file name
                                     (default)
    -l, --literal                    [deprecated] Alias of --title
    -w, --no-overwrites              Do not overwrite files
    -c, --continue                   Force resume of partially downloaded files.
                                     By default, youtube-dl will resume
                                     downloads if possible.
    --no-continue                    Do not resume partially downloaded files
                                     (restart from beginning)
    --no-part                        Do not use .part files - write directly
                                     into output file
    --no-mtime                       Do not use the Last-modified header to set
                                     the file modification time
    --write-description              Write video description to a .description
                                     file
    --write-info-json                Write video metadata to a .info.json file
    --write-annotations              Write video annotations to a
                                     .annotations.xml file
    --load-info-json FILE            JSON file containing the video information
                                     (created with the "--write-info-json"
                                     option)
    --cookies FILE                   File to read cookies from and dump cookie
                                     jar in
    --cache-dir DIR                  Location in the filesystem where youtube-dl
                                     can store some downloaded information
                                     permanently. By default $XDG_CACHE_HOME
                                     /youtube-dl or ~/.cache/youtube-dl . At the
                                     moment, only YouTube player files (for
                                     videos with obfuscated signatures) are
                                     cached, but that may change.
    --no-cache-dir                   Disable filesystem caching
    --rm-cache-dir                   Delete all filesystem cache files

  Thumbnail images:
    --write-thumbnail                Write thumbnail image to disk
    --write-all-thumbnails           Write all thumbnail image formats to disk
    --list-thumbnails                Simulate and list all available thumbnail
                                     formats

  Verbosity / Simulation Options:
    -q, --quiet                      Activate quiet mode
    --no-warnings                    Ignore warnings
    -s, --simulate                   Do not download the video and do not write
                                     anything to disk
    --skip-download                  Do not download the video
    -g, --get-url                    Simulate, quiet but print URL
    -e, --get-title                  Simulate, quiet but print title
    --get-id                         Simulate, quiet but print id
    --get-thumbnail                  Simulate, quiet but print thumbnail URL
    --get-description                Simulate, quiet but print video description
    --get-duration                   Simulate, quiet but print video length
    --get-filename                   Simulate, quiet but print output filename
    --get-format                     Simulate, quiet but print output format
    -j, --dump-json                  Simulate, quiet but print JSON information.
                                     See --output for a description of available
                                     keys.
    -J, --dump-single-json           Simulate, quiet but print JSON information
                                     for each command-line argument. If the URL
                                     refers to a playlist, dump the whole
                                     playlist information in a single line.
    --print-json                     Be quiet and print the video information as
                                     JSON (video is still being downloaded).
    --newline                        Output progress bar as new lines
    --no-progress                    Do not print progress bar
    --console-title                  Display progress in console titlebar
    -v, --verbose                    Print various debugging information
    --dump-pages                     Print downloaded pages encoded using base64
                                     to debug problems (very verbose)
    --write-pages                    Write downloaded intermediary pages to
                                     files in the current directory to debug
                                     problems
    --print-traffic                  Display sent and read HTTP traffic
    -C, --call-home                  Contact the youtube-dl server for debugging
    --no-call-home                   Do NOT contact the youtube-dl server for
                                     debugging

  Workarounds:
    --encoding ENCODING              Force the specified encoding (experimental)
    --no-check-certificate           Suppress HTTPS certificate validation
    --prefer-insecure                Use an unencrypted connection to retrieve
                                     information about the video. (Currently
                                     supported only for YouTube)
    --user-agent UA                  Specify a custom user agent
    --referer URL                    Specify a custom referer, use if the video
                                     access is restricted to one domain
    --add-header FIELD:VALUE         Specify a custom HTTP header and its value,
                                     separated by a colon ':'. You can use this
                                     option multiple times
    --bidi-workaround                Work around terminals that lack
                                     bidirectional text support. Requires bidiv
                                     or fribidi executable in PATH
    --sleep-interval SECONDS         Number of seconds to sleep before each
                                     download when used alone or a lower bound
                                     of a range for randomized sleep before each
                                     download (minimum possible number of
                                     seconds to sleep) when used along with
                                     --max-sleep-interval.
    --max-sleep-interval SECONDS     Upper bound of a range for randomized sleep
                                     before each download (maximum possible
                                     number of seconds to sleep). Must only be
                                     used along with --min-sleep-interval.

  Video Format Options:
    -f, --format FORMAT              Video format code, see the "FORMAT
                                     SELECTION" for all the info
    --all-formats                    Download all available video formats
    --prefer-free-formats            Prefer free video formats unless a specific
                                     one is requested
    -F, --list-formats               List all available formats of requested
                                     videos
    --youtube-skip-dash-manifest     Do not download the DASH manifests and
                                     related data on YouTube videos
    --merge-output-format FORMAT     If a merge is required (e.g.
                                     bestvideo+bestaudio), output to given
                                     container format. One of mkv, mp4, ogg,
                                     webm, flv. Ignored if no merge is required

  Subtitle Options:
    --write-sub                      Write subtitle file
    --write-auto-sub                 Write automatically generated subtitle file
                                     (YouTube only)
    --all-subs                       Download all the available subtitles of the
                                     video
    --list-subs                      List all available subtitles for the video
    --sub-format FORMAT              Subtitle format, accepts formats
                                     preference, for example: "srt" or
                                     "ass/srt/best"
    --sub-lang LANGS                 Languages of the subtitles to download
                                     (optional) separated by commas, use --list-
                                     subs for available language tags

  Authentication Options:
    -u, --username USERNAME          Login with this account ID
    -p, --password PASSWORD          Account password. If this option is left
                                     out, youtube-dl will ask interactively.
    -2, --twofactor TWOFACTOR        Two-factor authentication code
    -n, --netrc                      Use .netrc authentication data
    --video-password PASSWORD        Video password (vimeo, smotri, youku)

  Adobe Pass Options:
    --ap-mso MSO                     Adobe Pass multiple-system operator (TV
                                     provider) identifier, use --ap-list-mso for
                                     a list of available MSOs
    --ap-username USERNAME           Multiple-system operator account login
    --ap-password PASSWORD           Multiple-system operator account password.
                                     If this option is left out, youtube-dl will
                                     ask interactively.
    --ap-list-mso                    List all supported multiple-system
                                     operators

  Post-processing Options:
    -x, --extract-audio              Convert video files to audio-only files
                                     (requires ffmpeg or avconv and ffprobe or
                                     avprobe)
    --audio-format FORMAT            Specify audio format: "best", "aac",
                                     "vorbis", "mp3", "m4a", "opus", or "wav";
                                     "best" by default; No effect without -x
    --audio-quality QUALITY          Specify ffmpeg/avconv audio quality, insert
                                     a value between 0 (better) and 9 (worse)
                                     for VBR or a specific bitrate like 128K
                                     (default 5)
    --recode-video FORMAT            Encode the video to another format if
                                     necessary (currently supported:
                                     mp4|flv|ogg|webm|mkv|avi)
    --postprocessor-args ARGS        Give these arguments to the postprocessor
    -k, --keep-video                 Keep the video file on disk after the post-
                                     processing; the video is erased by default
    --no-post-overwrites             Do not overwrite post-processed files; the
                                     post-processed files are overwritten by
                                     default
    --embed-subs                     Embed subtitles in the video (only for mp4,
                                     webm and mkv videos)
    --embed-thumbnail                Embed thumbnail in the audio as cover art
    --add-metadata                   Write metadata to the video file
    --metadata-from-title FORMAT     Parse additional metadata like song title /
                                     artist from the video title. The format
                                     syntax is the same as --output, the parsed
                                     parameters replace existing values.
                                     Additional templates: %(album)s,
                                     %(artist)s. Example: --metadata-from-title
                                     "%(artist)s - %(title)s" matches a title
                                     like "Coldplay - Paradise"
    --xattrs                         Write metadata to the video file's xattrs
                                     (using dublin core and xdg standards)
    --fixup POLICY                   Automatically correct known faults of the
                                     file. One of never (do nothing), warn (only
                                     emit a warning), detect_or_warn (the
                                     default; fix file if we can, warn
                                     otherwise)
    --prefer-avconv                  Prefer avconv over ffmpeg for running the
                                     postprocessors (default)
    --prefer-ffmpeg                  Prefer ffmpeg over avconv for running the
                                     postprocessors
    --ffmpeg-location PATH           Location of the ffmpeg/avconv binary;
                                     either the path to the binary or its
                                     containing directory.
    --exec CMD                       Execute a command on the file after
                                     downloading, similar to find's -exec
                                     syntax. Example: --exec 'adb push {}
                                     /sdcard/Music/ && rm {}'
    --convert-subs FORMAT            Convert the subtitles to other format
                                     (currently supported: srt|ass|vtt)
