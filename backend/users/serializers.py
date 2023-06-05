from rest_framework import viewsets, permissions
from rest_framework import serializers
from .models import Section, Forum, Topic, Post, User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'password')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User.objects.create_user(
            email=validated_data['email'],
            username=validated_data['username'],
            password=validated_data['password']
        )
        return user

class SectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Section
        fields = "__all__"

class ForumSerializer(serializers.ModelSerializer):
    creator = UserSerializer(read_only=True)

    class Meta:
        model = Forum
        fields = ('id', 'title', 'description', 'section', 'creator', 'created_at', 'updated_at')

class ForumViewSet(viewsets.ModelViewSet):
    queryset = Forum.objects.all()
    serializer_class = ForumSerializer
    permission_classes = [permissions.IsAuthenticated]  

    def perform_create(self, serializer):
        serializer.save(creator=self.request.user)

class TopicSerializer(serializers.ModelSerializer):
    creator = UserSerializer(read_only=True)

    class Meta:
        model = Topic
        fields = ('id', 'title', 'description', 'creator', 'created_at', 'updated_at')

    def create(self, validated_data):
        creator = self.context['request'].user
        topic = Topic.objects.create(
            creator=creator,
            **validated_data
        )
        return topic

class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ('id', 'topic', 'author', 'message', 'created_at', 'updated_at')
