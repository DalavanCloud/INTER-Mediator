<?php
/*
 * INTER-Mediator Ver.@@@@2@@@@ Released @@@@1@@@@
 *
 *   by Masayuki Nii  msyk@msyk.net Copyright (c) 2014 Masayuki Nii, All rights reserved.
 *
 *   This project started at the end of 2009.
 *   INTER-Mediator is supplied under MIT License.
 */
require_once('../../INTER-Mediator.php');

IM_Entry(
    array(
        array(
            'name' => 'postalcode',
            'records' => 10,
            'maxrecords' => 10,
            'paging' => true,
        ),
    ),
    null,
    array('db-class' => 'PDO'),
    false
);