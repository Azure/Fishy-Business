net use D: \\ntfisheriesstore.file.core.windows.net\raw efmN1atTbzJquM6pNJp317V0pVWZKJMLNmpUhkU1/P+WrMdhzd5mee0kXc6wfztcR+MAQDbdsppbXdL9KATTag== /user:Azure\ntfisheriesstore

net use D: /delete


$acctKey = ConvertTo-SecureString -String "efmN1atTbzJquM6pNJp317V0pVWZKJMLNmpUhkU1/P+WrMdhzd5mee0kXc6wfztcR+MAQDbdsppbXdL9KATTag==" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\ntfisheriesstore", $acctKey
New-PSDrive -Name D -PSProvider FileSystem -Root "\\ntfisheriesstore.file.core.windows.net\raw" -Credential $credential


sudo mount -t cifs //ntfisheriesstore.file.core.windows.net/raw /mnt/z/ -o vers=3.0,username=ntfisheriesstore,password=efmN1atTbzJquM6pNJp317V0pVWZKJMLNmpUhkU1/P+WrMdhzd5mee0kXc6wfztcR+MAQDbdsppbXdL9KATTag==,dir_mode=0777,file_mode=0777,sec=ntlmssp

sudo mount -t cifs //ntfisheriesstore.file.core.windows.net/raw /mnt/z/ \
    -o vers=3.0,username=ntfisheriesstore,password=efmN1atTbzJquM6pNJp317V0pVWZKJMLNmpUhkU1/P+WrMdhzd5mee0kXc6wfztcR+MAQDbdsppbXdL9KATTag==,dir_mode=0777,file_mode=0777,sec=ntlmssp

$acctKey = ConvertTo-SecureString -String "efmN1atTbzJquM6pNJp317V0pVWZKJMLNmpUhkU1/P+WrMdhzd5mee0kXc6wfztcR+MAQDbdsppbXdL9KATTag==" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\ntfisheriesstore", $acctKey
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\ntfisheriesstore.file.core.windows.net\raw" -Credential $credential -Persist


    --environment-variables NumWords=5 MinLength=8


    VIDEO_FILE=BICPB3-20170519-5.MP4
VIDEO_DIR=/mnt/data/video/Bathhurst
UNPROCESSED_FRAMES_DIR=/mnt/data/dataprep/unprocessed
ANALYZED_RESULTS_DIR=/mnt/data/dataprep/analyzed
PROCESSED_FRAMES_DIR=/mnt/data/dataprep/processed


docker run -v /mnt/z:/mnt/z -other -options ntfish-dataprep sh