#coding=utf-8
#from games import GameInfo
#from scraper import SearchResult
__author__ = 'ron975'
"""
This file is part of Snowflake.Core
"""

from urllib import parse, request
from collections import namedtuple
import re
import os
import yaml
import scraper
#import constants

__scrapername__ = "TheGamesDB"
__scraperauthor__ = ["Angelscry", "ron975"]
__scrapersite__ = "thegamesdb.net"
__scraperdesc__ = "Scrapes ROM information from TheGamesDB API"
__scraperfanarts__ = True
__scraperpath__ = os.path.dirname(os.path.realpath(__file__))
__scrapermap__ = yaml.load(open(os.path.join(__scraperpath__, "scrapermap.yml")))

key_boxarts = "ICELAKE_IMG_GAME_BOXARTS"
loadables_path = os.path.join(os.path.abspath(os.path.dirname(__file__)), 'loadables')


class SearchResult(namedtuple('SearchResult', 'game_title source_id')):
    pass


class ScraperInfo:
    def __init__(self, name, filename):
        self.name = name
        self.scraper =  imp.load_source('.'.join(['scraper', name]), filename)

class GameInfo:
    def __init__(self, title, publisher, description, genre,
                 release_date, platform="NINTENDO_SNES", images={}, metadata=[]):
        self.title = title
        self.publisher = publisher
        self.platform = platform
        self.description = description
        self.genre = genre
        self.release_date = release_date
        self.metadata = metadata
        self.images = images

    @classmethod
    def deserialize(cls, title, publisher, description, genre, release_date, platform, images, metadata):
        return cls(title, publisher, description, genre, release_date.split('-'), platform,
                   json.loads(images.replace("'", '"')), json.loads(metadata.replace("'", '"')))

    def serialize_releasedate(self):
        return '-'.join(str(value) for value in self.release_date)

    def serialize_images(self):
        return json.dumps(self.images).replace('"', "'")

    def serialize_metadata(self):
        return json.dumps(self.metadata).replace('"', "'")

def order_by_best_match(game_searches, game_name):
    return sorted(game_searches, key=lambda result: difflib.SequenceMatcher(None, result["title"], game_name).ratio(), reverse=True)

def get_best_from_results(game_searches, game_name):
    best_match = {}
    best_ratio = 0
    for scraper, game_search in list(game_searches.items()):
        try:
            if difflib.SequenceMatcher(None, game_search["title"], game_name).ratio() > best_ratio:
                best_ratio = difflib.SequenceMatcher(None, game_search["title"], game_name).ratio()
                best_match = {"scraper": scraper, "search": game_search}
        except KeyError:
            pass

    return best_match


def get_best_search_result(game_list, game_name):
    best_match = {}
    best_ratio = 0
    for game in game_list:
        if difflib.SequenceMatcher(None, game["title"], game_name).ratio() > best_ratio:
            best_ratio = difflib.SequenceMatcher(None, game["title"], game_name).ratio()
            best_match = game

    return best_match


def format_html_codes(s):
    """
    :author: Angelscry
    Replaces HTML character codes into their proper characters
    :return:
    """
    s = s.replace('<br />', ' ')
    s = s.replace("&lt;", "<")
    s = s.replace("&gt;", ">")
    s = s.replace("&amp;", "&")
    s = s.replace("&#039;", "'")
    s = s.replace('<br />', ' ')
    s = s.replace('&quot;', '"')
    s = s.replace('&nbsp;', ' ')
    s = s.replace('&#x26;', '&')
    s = s.replace('&#x27;', "'")
    s = s.replace('&#xB0;', "°")
    s = s.replace('\xe2\x80\x99', "'")
    return s


def get_games_by_name(search):
    results = []
    try:
        req = request.Request('http://thegamesdb.net/api/GetGamesList.php?name='+parse.quote_plus(search))
        req.add_unredirected_header('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31')
        f = request.urlopen(req)
        page = f.read().decode('utf-8').replace('\n','')
        games = re.findall("<Game><id>(.*?)</id><GameTitle>(.*?)</GameTitle>(.*?)<Platform>(.*?)</Platform></Game>",
                           page)
        for item in games:
            game = {}
            game["id"] = "http://thegamesdb.net/api/GetGame.php?id=" + item[0]
            game["title"] = item[1]
            game["system"] = item[3]
            game["order"] = 1
            if game["title"].lower() == search.lower():
                game["order"] += 1
            if game["title"].lower().find(search.lower()) != -1:
                game["order"] += 1
            results.append(game)
        results.sort(key=lambda result: result["order"], reverse=True)
        return [SearchResult(result["title"], result["id"]) for result in results]
    except UnboundLocalError:
        return None


def get_games_with_system(search, system):
    scraper_sysid = __scrapermap__[system]
    results = []
    try:
        req = request.Request('http://thegamesdb.net/api/GetGamesList.php?name='+parse.quote_plus(search)+'&platform='+parse.quote_plus(scraper_sysid))
        req.add_unredirected_header('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31')
        f = request.urlopen(req)
        page = f.read().decode('utf-8').replace('\n','')
        if system == "Sega Genesis":
            req = request.Request('http://thegamesdb.net/api/GetGamesList.php?name='+parse.quote_plus(search)+'&platform='+parse.quote_plus('Sega Mega Drive'))
            req.add_unredirected_header('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31')
            f2 = request.urlopen(req)
            page = page + f2.read().replace("\n", "")
        games = re.findall("<Game><id>(.*?)</id><GameTitle>(.*?)</GameTitle>(.*?)<Platform>(.*?)</Platform></Game>",
                           page)
        for item in games:
            game = {}
            game["id"] = item[0]
            game["title"] = item[1]
            game["system"] = item[3]
            game["order"] = 1
            if game["title"].lower() == search.lower():
                game["order"] += 1
            if game["title"].lower().find(search.lower()) != -1:
                game["order"] += 1
            if game["system"] == scraper_sysid:
                game["system"] = system
                results.append(game)
        results.sort(key=lambda result: result["order"], reverse=True)
        return [SearchResult(result["title"], result["id"]) for result in results]
    except:
        return None


def get_game_datas(game_id):
    gamedata = {
        'title': "",
        'genre': "",
        'release': "",
        'publisher': "",
        'description': ""
    }

    try:
        req = request.Request("http://thegamesdb.net/api/GetGame.php?id=" + game_id)
        req.add_unredirected_header('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31')
        f = request.urlopen(req)
        page = f.read().decode('utf-8').replace('\n','')
        game_genre = ' / '.join(re.findall('<genre>(.*?)</genre>', page))
        if game_genre:
            gamedata["genre"] = format_html_codes(game_genre)
        game_release = ''.join(re.findall('<ReleaseDate>(.*?)</ReleaseDate>', page))
        if game_release:
            gamedata["release"] = format_html_codes(game_release)
        game_studio = ''.join(re.findall('<Publisher>(.*?)</Publisher>', page))
        if game_studio:
            gamedata["publisher"] = format_html_codes(game_studio)
        game_plot = ''.join(re.findall('<Overview>(.*?)</Overview>', page))
        if game_plot:
            gamedata["description"] = format_html_codes(game_plot)
        game_title = ''.join(re.findall('<GameTitle>(.*?)</GameTitle>', page))
        if game_title:
            gamedata["title"] = format_html_codes(game_title)
        boxarts = re.findall(r'<boxart side="front" (.*?)">(.*?)</boxart>', page)[0][1]
        boxarts = "http://thegamesdb.net/banners/" + boxarts

        return GameInfo(
            title=gamedata["title"],
            publisher=gamedata["publisher"],
            description=gamedata["description"],
            release_date=[gamedata["release"].split("/")[2],
                          gamedata["release"].split("/")[0],
                          gamedata["release"].split("/")[1]],
            genre=gamedata["genre"],

            images={
                key_boxarts: boxarts
            }
        )
    except UnboundLocalError:

        return None
