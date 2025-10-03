<?php
/**
 * Plugin Name: Serizo Dashboard
 * Description: Custom WordPress plugin for Serlzo Dashboard.
 * Version: 1.1
 * Author: Daniel Ezeali
 */

if ( ! defined( 'ABSPATH' ) ) exit;

function serizo_add_admin_page() {
    add_menu_page(
        'Serizo Dashboard',
        'Serizo Dashboard',
        'manage_options',
        'serizo-dashboard',
        'serizo_render_admin_page',
        'dashicons-layout',
        3
    );
}
add_action( 'admin_menu', 'serizo_add_admin_page' );

function serizo_enqueue_assets( $hook ) {
    if ( $hook !== 'toplevel_page_serizo-dashboard' ) return;

    // Bootstrap CSS
    wp_enqueue_style(
        'serizo-bootstrap',
        plugins_url( 'assets/dist/css/bootstrap.min.css', __FILE__ )
    );

    // Main CSS
    wp_enqueue_style(
        'serizo-main',
        plugins_url( 'assets/css/index.css', __FILE__ ),
        array( 'serizo-bootstrap' ),
        '1.0'
    );

    // Optional responsive/media CSS
    wp_enqueue_style(
        'serizo-media',
        plugins_url( 'assets/css/media.css', __FILE__ ),
        array( 'serizo-main' ),
        '1.0'
    );

    // Bootstrap JS (the bundle already includes Popper)
    wp_enqueue_script(
        'serizo-bootstrap',
        plugins_url( 'assets/dist/js/bootstrap.bundle.js', __FILE__ ),
        array( 'jquery' ),
        null,
        true
    );

    // Your JS
    wp_enqueue_script(
        'serizo-script',
        plugins_url( 'assets/js/index.js', __FILE__ ),
        array( 'jquery', 'serizo-bootstrap' ), // depend on bootstrap
        '1.0',
        true
    );
}
add_action( 'admin_enqueue_scripts', 'serizo_enqueue_assets' );




function serizo_render_admin_page() {
    include plugin_dir_path( __FILE__ ) . 'admin-page.php';
}

require plugin_dir_path(__FILE__) . 'plugin-update-checker/plugin-update-checker.php';

use YahnisElsts\PluginUpdateChecker\v5\PucFactory;

$updateChecker = PucFactory::buildUpdateChecker(
    'https://serlzo.spellahub.com/serlzo-wp.json', // manifest URL
    __FILE__,
    'serlzo'
);

