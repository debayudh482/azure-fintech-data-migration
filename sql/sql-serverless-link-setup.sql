CREATE DATABASE ReadExternalDataDB; 

CREATE EXTERNAL DATA SOURCE FintechDataExternal
WITH (
    LOCATION = 'https://<your_storage_account>.dfs.core.windows.net/<container_name>'
);
