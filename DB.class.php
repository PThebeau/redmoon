<?php
	class DB {
		function __construct() {
			global $CONFIG;

			$this->connection = odbc_connect($CONFIG['db']['name'], $CONFIG['db']['username'], $CONFIG['db']['password']);
			if (!$this->connection) {
				gdie("Could not connect to database.");
			}
		}

		function query($query, $data = array()) {
			global $numqueries;

			ob_start();
			$stmt = odbc_prepare($this->connection, $query);
			$res = odbc_execute($stmt, $data);
			$out = ob_get_contents();
			ob_end_clean();

			if ($out) {
				echo "<!-- DB warning:\n$query\n";
				print_r($data);
				echo "\n$out -->";
			}

			if (!$stmt) {
				gdie("Database query failed:\n<br />$query\n<br />" . odbc_get_last_message());
			}

			$numqueries++;

			return new Result($stmt);
		}

		function insert($table, $data) {
			$this->query("INSERT INTO $table (" . implode(', ', array_keys($data)) . ') VALUES (' . substr(str_repeat('?, ', count($data)), 0, -2) . ')', array_values($data));
		}
		
		function begin() {
			$this->query('BEGIN');
		}
		
		function commit() {
			$this->query('COMMIT');
		}
		
		function rollback() {
			$this->query('ROLLBACK');
		}
		
		static function escape($string) {
			return addslashes($string);
		}
	}
?>
