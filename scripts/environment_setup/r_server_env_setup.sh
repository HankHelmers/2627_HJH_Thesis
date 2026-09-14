
# Environment to run Rscripts from server
conda create -n r_server_env r-base r-essentials -c conda-forge

conda activate r_server_env

# Create folder for local rstudio server
mkdir -p ~/rstudio-server-local # in ~/.local

# Download onto server in local 
wget https://dl.dailies.rstudio.com/server/jammy/amd64/rstudio-server-2026.09.0-174-amd64.deb
dpkg-deb -x rstudio-server-2026.09.0-174-amd64.deb ~/rstudio-server-local

mkdir -p ~/rstudio-server-data
mkdir -p ~/rstudio-server-data/db

echo "provider=sqlite" > ~/rstudio-server-data/database.conf
echo "directory=$HOME/rstudio-server-data/db" >> ~/rstudio-server-data/database.conf

cat /proc/sys/kernel/random/uuid > ~/rstudio-server-data/secure-cookie-key
chmod 600 ~/rstudio-server-data/secure-cookie-key

~/rstudio-server-local/usr/lib/rstudio-server/bin/rserver \
  --server-daemonize=0 \
  --www-port=8787 \
  --secure-cookie-key-file=$HOME/rstudio-server-data/secure-cookie-key \
  --server-pid-file=$HOME/rstudio-server-data/rserver.pid \
  --server-data-dir=$HOME/rstudio-server-data \
  --database-config-file=$HOME/rstudio-server-data/database.conf \
  --rsession-which-r=$(which R) \
  --rsession-ld-library-path=$CONDA_PREFIX/lib \
  --server-user=$USER

# On local computer
ssh -N -L 8787:slurm:8787 helmerhj@slurm.csse.rose-hulman.edu

# Browser 
http://localhost:8787

# In browser Terminal, connect conda env 
Tools/GlobalOptions/Python/select conda env

# And
# In R console
file.edit("~/.Renviron")

# Paste env
R_LIBS_USER="/home/helmerhj/miniconda3/envs/r_popgen_env/lib/R/library"