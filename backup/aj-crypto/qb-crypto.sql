CREATE TABLE IF NOT EXISTS `crypto` (
  `crypto` varchar(50) NOT NULL DEFAULT 'ajit',
  `worth` int(11) NOT NULL DEFAULT 0,
  `history` text DEFAULT NULL,
  PRIMARY KEY (`crypto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `crypto` VALUES ('ajit', 1000, '[{"NewWorth":1000,"PreviousWorth":1000}]');
