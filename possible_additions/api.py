#from urllib import request
import urllib.request, urllib.parse, urllib.error
import xml.etree.ElementTree as ET
from urlutils import urlencode_no_plus

class Game(object):

    def __init__(self, id, title, release_date=None, platform=None, overview=None, esrb_rating=None,
                 genres=None, players=None, coop=None, youtube_url=None, publisher=None, developer=None, rating=None,
                 logo_url=None):
        self.id = id
        self.title = title
        self.release_date = release_date
        self.platform = platform
        self.overview = overview
        self.esrb_rating = esrb_rating
        self.genres = genres
        self.players = players
        self.coop = coop
        self.youtube_url = youtube_url
        self.publisher = publisher
        self.developer = developer
        self.rating = rating
        self.logo_url = logo_url

class Platform(object):

    def __init__(self, id, name, alias=None, console=None, controller=None, graphics=None, max_controllers=None,rating=None,
                 display=None, manufacturer=None, cpu=None, memory=None, sound=None, media=None, developer=None,
                 overview=None):
        self.id = id
        self.name = name
        self.alias = alias
        self.console = console
        self.controller = controller
        self.overview = overview
        self.developer = developer
        self.manufacturer = manufacturer
        self.cpu = cpu
        self.memory = memory
        self.graphics = graphics
        self.sound = sound
        self.display = display
        self.media = media
        self.max_controllers = max_controllers
        self.rating = rating

class APIException(Exception):
    def __init__(self, msg):
        self.msg = msg
    def __str__(self):
        return self.msg

class API(object):

    @staticmethod
    def make_call(api_url, query_args=None):
        # api_url is expected to be the fully constructed URL, with any needed arguments appended.
        # This function will simply make the call, and return the response as an ElementTree object for parsing,
        # If response cannot be parsed because it is not valid XML, this function assumes an API error and raises an
        # APIException, passing forward the pages contents (which generally gives some indication of the error.
        if query_args is not None:
            get_params = urlencode_no_plus.urlencode_no_plus(query_args)
            response = urllib.request.urlopen(api_url+'%s' % get_params)
        else:
            response = urllib.request.urlopen(api_url)
        page = response.read()

        # Make sure the XML Parser doesn't return a ParsError.  If it does, it's probably and API Issue, so raise an
        # exception, printing the response from the API call.
        try:
            xml_response = ET.fromstring(page)
        except ET.ParseError:
            raise APIException(page)
        return  xml_response

    def get_platforms_list(self):
        platforms_list = []
        GET_PLATFORMS_LIST_ENDPOINT = 'http://thegamesdb.net/api/GetPlatformsList.php'
        xml_response = self.make_call(GET_PLATFORMS_LIST_ENDPOINT)
        for element in xml_response.iter(tag="Platform"):
            for subelement in element:
                if subelement.tag == 'id':
                    platform_id = subelement.text
                if subelement.tag == 'name':
                    platform_name = subelement.text
                if subelement.tag == 'alias':
                    platform_alias = subelement.text
            platforms_list.append(Platform(platform_id, platform_name, alias=platform_alias))

        return platforms_list

    def get_platform(self, id):
        # TODO Add support for fetching platform images under the <Images> element
        GET_PLATFORM_ENDPOINT = 'http://thegamesdb.net/api/GetPlatform.php?'
        query_args = {'id': id}
        xml_response = self.make_call(GET_PLATFORM_ENDPOINT, query_args)
        # TODO These are all optional fields.  There's probably a better way to handle this than setting them all to None.
        platform_id = None
        platform_name = None
        platform_console = None
        platform_controller = None
        platform_graphics = None
        platform_max_controllers = None
        platform_rating = None
        platform_display = None
        platform_manufacturer = None
        platform_cpu = None
        platform_memory = None
        platform_sound = None
        platform_media = None
        platform_developer = None
        platform_overview = None
        for element in xml_response.iter(tag="Platform"):
            for subelement in element:
                if subelement.tag == 'id':
                    platform_id = subelement.text
                if subelement.tag == 'Platform':
                    platform_name = subelement.text
                if subelement.tag == 'console':
                    platform_console = subelement.text
                if subelement.tag == 'controller':
                    platform_controller = subelement.text
                if subelement.tag == 'overview':
                    platform_overview = subelement.text
                if subelement.tag == 'developer':
                    platform_developer = subelement.text
                if subelement.tag == 'manufacturer':
                    platform_manufacturer = subelement.text
                if subelement.tag == 'cpu':
                    platform_cpu = subelement.text
                if subelement.tag == 'memory':
                    platform_memory = subelement.text
                if subelement.tag == 'graphics':
                    platform_graphics = subelement.text
                if subelement.tag == 'sound':
                    platform_sound = subelement.text
                if subelement.tag == 'display':
                    platform_display = subelement.text
                if subelement.tag == 'media':
                    platform_media = subelement.text
                if subelement.tag == 'max_controllers':
                    platform_max_controllers = subelement.text
                if subelement.tag == 'rating':
                    platform_rating = subelement.text
        if (platform_id == None or platform_name == None):
            raise APIException("get_platform returned a result without required fields id or platform")
        return Platform(platform_id, platform_name, console=platform_console, controller=platform_controller,
                        graphics=platform_graphics, max_controllers=platform_max_controllers, rating=platform_rating,
                        display=platform_display, manufacturer=platform_manufacturer, cpu=platform_cpu,
                        memory=platform_memory, sound=platform_sound, media=platform_media, developer=platform_developer,
                        overview=platform_overview)

    def get_platform_games(self, platform_id):
        GET_PLATFORM_GAMES_LIST_ENDPOINT = 'http://thegamesdb.net/api/GetPlatformGames.php?'
        query_args = {'platform': platform_id}
        xml_response = self.make_call(GET_PLATFORM_GAMES_LIST_ENDPOINT, query_args)
        platform_games_list = []
        for element in xml_response.iter(tag="Game"):
            platform_games_list_release_date = None
            for subelement in element:
                if subelement.tag == 'id':
                    platform_games_list_id = subelement.text
                if subelement.tag == 'GameTitle':
                    platform_games_list_name = subelement.text
                if subelement.tag == 'ReleaseDate':
                    # platform_games_list_release_date = datetime.strptime(subelement.text, "%m/%d/%Y")
                    # Omitting line above since date comes back in an inconsistent format, for example only %Y
                    platform_games_list_release_date = subelement.text
            platform_games_list.append(Game(platform_games_list_id, platform_games_list_name,
                                            release_date=platform_games_list_release_date))
        return platform_games_list

    def get_game(self, id=None, name=None, platform=None):
        if id is not None and name is not None:  # One of these arguments must be passed
            return None
        else:
            query_args = {}
            if id is not None:
                query_args['id'] = id
            if name is not None:
                query_args['name'] = name
            if platform is not None:
                query_args['platform'] = platform
        GET_GAME_ENDPOINT = 'http://thegamesdb.net/api/GetGame.php?'
        xml_response = self.make_call(GET_GAME_ENDPOINT, query_args)
        games_list = []
        game_base_img_url = None
        for element in xml_response.iter(tag="baseImgUrl"):
            game_base_img_url = element.text
        for element in xml_response.iter(tag="Game"):
            game_overview = None
            game_release_date = None
            game_esrb_rating = None
            game_youtube_url = None
            game_rating = None
            game_logo_url = None
            game_players = None
            game_coop = None
            game_genres = None
            game_publisher = None
            game_developer = None
            for subelement in element:
                if subelement.tag == 'id':
                    game_id = subelement.text
                if subelement.tag == 'GameTitle':
                    game_title = subelement.text
                if subelement.tag == 'Platform':
                    game_platform = subelement.text
                if subelement.tag == 'ReleaseDate':
                    # games_release_date = datetime.strptime(subelement.text, "%m/%d/%Y")
                    game_release_date = subelement.text
                if subelement.tag == 'Overview':
                    game_overview = subelement.text
                if subelement.tag == 'ESRB':
                    game_esrb_rating = subelement.text
                if subelement.tag == 'Genres':
                    game_genres = ''
                    for genre_element in subelement.iter(tag="genre"):
                        # TODO put elements in a more appropriate data structure
                        game_genres += genre_element.text
                if subelement.tag == 'Players':
                    game_players = subelement.text
                if subelement.tag == 'Co-op':
                    if subelement.text == 'No':
                        game_coop = False
                    elif subelement.text == 'Yes':
                        game_coop = True
                if subelement.tag == 'Youtube':
                    game_youtube_url = subelement.text
                if subelement.tag == 'Publisher':
                    game_publisher = subelement.text
                if subelement.tag == 'Developer':
                    game_developer = subelement.text
                if subelement.tag == 'Rating':
                    game_rating = subelement.text
                if subelement.tag == 'clearlogo':
                    # TODO Capture image dimensions from API resposne
                    game_logo_url = game_base_img_url + subelement.text
            games_list.append(Game(game_id, game_title, release_date=game_release_date, platform=game_platform,
                               overview=game_overview, esrb_rating=game_esrb_rating, genres=game_genres,
                               players=game_players, coop=game_coop, youtube_url=game_youtube_url,
                               publisher=game_publisher, developer=game_developer, rating=game_rating,
                               logo_url=game_logo_url))

        if len(games_list) == 0:
            return None
        elif len(games_list) == 1:
            return games_list[0]
        else:
            return games_list

    def get_games_list(self, name, platform=None, genre=None):
        query_args = {'name': name}
        if platform is not None:
            query_args['platform'] = platform
        if genre is not None:
            query_args['genre'] = genre
        games_list = []
        GET_GAMES_LIST_ENDPOINT = 'http://thegamesdb.net/api/GetGamesList.php?'
        xml_response = self.make_call(GET_GAMES_LIST_ENDPOINT, query_args)
        for element in xml_response.iter(tag="Game"):
            game_release_date = None
            game_platform = None
            for subelement in element:
                if subelement.tag == 'id':
                    game_id = subelement.text
                if subelement.tag == 'GameTitle':
                    game_title = subelement.text
                if subelement.tag == 'ReleaseDate':
                    game_release_date = subelement.text
                if subelement.tag == 'Platform':
                    game_platform = subelement.text
            games_list.append(Game(game_id, game_title, release_date=game_release_date, platform=game_platform))
        return games_list






