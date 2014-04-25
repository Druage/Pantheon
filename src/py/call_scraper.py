
import os
import sys

scraper_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'scrapers', 'thegamesdb')
sys.path.append(scraper_path)

import scraper

def consoles(console):
    return {'Nintendo 64': 'NINTENDO_N64',
            'Nintendo Entertainment System': 'NINTENDO_NES',
            'Super Nintendo': 'NINTENDO_SNES',
            'Game Boy': 'NINTENDO_GB',
            'Game Boy Color': 'NINTENDO_GBC',
            'Game Boy Advance': 'NINTENDO_GBA',
            'Sega Genesis': 'SEGA_GEN',
            'Sony PlayStation': 'SONY_PSX',
            'Atari 2600': 'ATARI_2600'}.get(console, None)

def get_data(title=None, system=None):
    '''Calls the game scraper for info, descriptions, images, etc.
    '''
    console = consoles(system)
    try:
        if console:
            result = scraper.get_games_with_system(title, console)
            if len(result) != 0 or result is not None:
                for entry in result:
                    game_id = entry.source_id
                    data = scraper.get_game_datas(game_id)
                    break
                return {'images': data.images['ICELAKE_IMG_GAME_BOXARTS'],
                        'description': data.description,
                        'publisher': data.publisher,
                        'genre': data.genre}
            else:
                raise
    except:
        return None
