# jupyternotebook-reverseproxy
Repository to hold code for the reverse proxy service
# Contents
`start_notebook` is the script executed by the user to start their job. It is aware of all information needed for the user to interact with their notebook, including the url, port on the compute node, and Jupyter Notebook token.
`batch_notebook` is the script that is executed by slurm on the comet compute node. It starts the notebook and write information to ~/.jupyter_secure

# To launch a jupyter notebook (01/31/2020)
run the following command to start the notebook at a given path:
`./start_notebook` <path>

# Configuration
Currently, all configuration must be done manually by the user by editing copies of the scripts.
They can edit their compute node requirements in the batch_notebook script.

# Working Notebooks
Python Series: [https://github.com/sinkovit/PythonSeries]
