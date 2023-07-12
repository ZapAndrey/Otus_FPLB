<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/documentation/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress_db' );

/** Database username */
define( 'DB_USER', 'wordpressuser' );

/** Database password */
define( 'DB_PASSWORD', '!PressUser1' );

/** Database hostname */
define( 'DB_HOST', '172.20.21.54' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '`w pdyc3LD{Dn{e>5.pKoVD0:LOZ?bDz|qPWtK{Nx%Mtf7x!xiu0%`0KT)]/rAEP' );
define( 'SECURE_AUTH_KEY',  'J%Y H;(n;Y4u7A*>jC4qU~;P^ikS$ldlAE7ls_]Q5$?7EGyJ@HXy&PvYU56,:PTW' );
define( 'LOGGED_IN_KEY',    'zghXSTAjPEcg/D(5K+pRu*vKj>|:Vr#NE)USc:511NrTZ.s)#uqeF6R(V-5Xr^wY' );
define( 'NONCE_KEY',        '@G-6a!T6vG(ok<v-VjF@DVpa*];ysip-WwUc-H.5-OiQP7^~Dm&wRu$-I%Z+ =@$' );
define( 'AUTH_SALT',        'DgSb{]8:eN9l3Wk9(:;St$v/`*-gx=X04&OXC)yKdds0q-CYBfrVX>nAA@!$;AjI' );
define( 'SECURE_AUTH_SALT', 'M(:M~o+cC^gN;5EC8=rB4ugVDRF>x:1CqOs-XI%)Q$4ohgo vq0ifFTer9*Ac en' );
define( 'LOGGED_IN_SALT',   ';ZIU-L>O] bg{MAH{s`jQ1EfoUOdwSR87*M(hu$RI01CDmPN*a`h&LM0V,P!fB+F' );
define( 'NONCE_SALT',       'K`eiF/`8jl7(-`dL%RG$by;A;{w3y@C,)-sXPWv]Lp7Gb`,sp4WdoO.e+(+`{K n' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
