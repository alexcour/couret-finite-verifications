<?php
/**
 * Plugin Name: Couret — Laboratoire public modulo 30
 * Description: Deux shortcodes statiques pour l'Observatoire Couret, sans accès au laboratoire privé.
 * Version: 0.1.0
 * Author: Alexandre Couret
 * License: GPL-2.0-or-later
 * Text Domain: couret-mod30-public
 */
if (!defined('ABSPATH')) {
    exit;
}

/**
 * Frames ship only the explicitly reviewed public assets bundled with this plugin.
 * No remote fetch, API keys, WordPress database writes, analytics or auto-posting.
 */
function couret_mod30_public_frame($attributes = array(), $content = null, $tag = '') {
    $is_journal = ($tag === 'couret_mod30_journal');
    if ($tag !== 'couret_mod30' && !$is_journal) {
        return '';
    }
    $file = $is_journal ? 'journal.html' : 'index.html';
    $title = $is_journal
        ? 'Journal public des recherches vérifiables — Observatoire Couret'
        : 'Permutations interactives des unités modulo 30 — Observatoire Couret';
    $height = $is_journal ? 1050 : 1550;
    $url = plugins_url($file, __FILE__);
    return '<iframe src="' . esc_url($url) . '" title="' . esc_attr($title) .
        '" loading="lazy" referrerpolicy="no-referrer" sandbox="allow-scripts" ' .
        'style="display:block;width:100%;height:' . (int)$height .
        'px;border:1px solid #8994a9;border-radius:12px" ' .
        'aria-label="' . esc_attr($title) . '"></iframe>';
}
add_shortcode('couret_mod30', 'couret_mod30_public_frame');
add_shortcode('couret_mod30_journal', 'couret_mod30_public_frame');
