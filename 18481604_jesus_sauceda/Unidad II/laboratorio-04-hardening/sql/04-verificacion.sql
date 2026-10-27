SELECT 
    current_user,
    current_database(),
    inet_client_addr(),
    inet_client_port(),
    version();

SELECT 
    count(*) AS conexiones_activas 
FROM pg_stat_activity 
WHERE state = 'active';

SELECT 
    name, 
    setting, 
    unit, 
    short_desc 
FROM pg_settings 
WHERE name IN ('max_connections', 'password_encryption', 'statement_timeout', 'idle_in_transaction_session_timeout');