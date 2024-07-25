<?php
	class Result {
		public $data = array();

		function __construct($result) {
			$this->result = $result;
		}

		function fetch() {
			$this->data = odbc_fetch_array($this->result);
			return $this->data;
		}
		
		function __get(&$key) {
			if (isset($this->data[$key])) {
				return $this->data[$key];
			}
		}
		
		function num_rows() {
			$rows = odbc_num_rows($this->result);
			if ($rows === -1) {
				return false;
			} else {
				return $rows;
			}
		}

		function __destruct() {
			odbc_free_result($this->result);
		}
	}
?>
