
import os
import sys

scraper_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'scrapers', 'thegamesdb')
sys.path.append(scraper_path)

import scraper

def get_data(title=None, system=None):
    '''Calls the game scraper for info, descriptions, images, etc.
    '''
    consoles = {'Nintendo 64': 'NINTENDO_N64',
               'Nintendo Entertainment System': 'NINTENDO_NES',
               'Super Nintendo': 'NINTENDO_SNES',
               'Game Boy': 'NINTENDO_GB',
               'Game Boy Color': 'NINTENDO_GBC',
               'Game Boy Advance': 'NINTENDO_GBA',
               'Sega Genesis': 'SEGA_GEN',
               'Sony PlayStation': 'SONY_PSX',
               'Atari 2600': 'ATARI_2600'}
    try:
        system = consoles[system]
        result = scraper.get_games_with_system(title, system)
        #result = scraper.get_game_datas(game_id)
        for num, entry in enumerate(result[0]):
            if num == 1:
                game_id = entry
        data = scraper.get_game_datas(game_id)
        return {'genre': data.genre, 'images': data.images['ICELAKE_IMG_GAME_BOXARTS'],
                'description': data.description, 'publisher': data.publisher}
    except:
        return {'genre': '', 'images': '',
                'description': '', 'publisher': ''}
